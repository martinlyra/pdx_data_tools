import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:pdx_data_tools/src/metadata/data_object.dart';

import 'package:source_gen/source_gen.dart';

// TODO: Devise a builder that makes use of object_factory.dart

/*
 * Entry point for pdx_data_tool's code generation
 */
Builder pdxDataObjectBuilder(BuilderOptions options) {
  return LibraryBuilder(
      new PdxDataObjectFactoryGenerator(),
      generatedExtension: ".pdt_factory.g.dart"
  );
}

class PdxDataObjectFactoryGenerator implements Generator {

  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) {
    // Collect directives for the compiler
    List<_CompilerDirective> compilerDirectives = [];
    for (var element in library.classElements) {
      var directive = element.accept(new _DataObjectVisitor(library));
      if (directive != null)
        compilerDirectives.add(directive);
    }

    if (compilerDirectives.isEmpty) return null;

    // Do actual compiling
    List<String> outputs = [];
    outputs.add(_generateHeaderCode(library, compilerDirectives));
    for (var directive in compilerDirectives) {
      outputs.add(_generateFactoryCode(library, directive));
    }
    return outputs.join("\n");
  }

  /**
   * Generates a string block containing the proper imports required for the
   * code to work
   */
  String _generateHeaderCode
      (LibraryReader library, List<_CompilerDirective> directives) {
    final buffer = new StringBuffer();

    // Collect source files
    var sources = List();
    for (var directive in directives) {
      var targetClass = directive.targetClass.key;
      var fields = directive.targetFields.keys;
      var classSource = targetClass.source;

      if (!sources.contains(classSource))
        sources.add(classSource);

      for (var field in fields) {
        var source = field.type.element.source;
        if (source.isInSystemLibrary)
          continue;
        if (!sources.contains(source))
          sources.add(source);
      }
    }

    // TODO: Handle references from external libraries
    for (var source in sources) {
      buffer.write('import \'${source.shortName}\';\n');
    }

    return buffer.toString();
  }

  /**
   * Monolithic function for generating static factory methods for
   * deserialization of designated objects
   */
  String _generateFactoryCode
      (LibraryReader library, _CompilerDirective directive) {
    final buffer = new StringBuffer();

    var targetClass = directive.targetClass;

    var classTypeRef = targetClass.key.type;

    buffer.write(
        '$classTypeRef deserialize$classTypeRef(String key, Map map) {\n');
    buffer.write('final inst = new $classTypeRef();\n');

    for (var field in directive.targetFields.keys) {
      var annotation = directive.targetFields[field].computeConstantValue();

      var key = annotation.getField("name").toStringValue();
      var val = annotation.getField("defaultValue");

      var valType = val.type;
      var valVal = valType.name == "Type" ? null : val.toString();
      var fieldName = field.name;
      var fieldType = field.type;

      buffer.write(
          'inst.$fieldName = '
              'map.containsKey(\'$key\') ? map[\'$key\'] as $fieldType : $valVal;\n'
      );
    }
    buffer.write('return inst;\n' '}\n');

    return buffer.toString();
  }
}

class _CompilerDirective {
  final MapEntry<ClassElement, ElementAnnotation> targetClass;
  final Map<FieldElement, ElementAnnotation> targetFields;

  _CompilerDirective(this.targetClass, this.targetFields);
}

class _DataObjectVisitor extends RecursiveElementVisitor<_CompilerDirective> {
  final LibraryReader _libraryReader;

  _DataObjectVisitor(this._libraryReader);

  final _dataFields = Map<FieldElement, ElementAnnotation>();

  @override _CompilerDirective visitClassElement(ClassElement element) {
    final annotation = element.metadata.firstWhere(
            (metadata) => _matchAnnotationType(PdxDataObject, metadata),
        orElse: () => null
    );
    if (annotation == null) return null;
    if (element.isPrivate) {
      log.severe(
          'Objects with the PdxDataObject annotation should be public: '
              '$element'
      );
      return null;
    }

    // Visit class members
    super.visitClassElement(element);

    return
      new _CompilerDirective(
          new MapEntry(element, annotation)
          , _dataFields
      );
  }

  @override visitFieldElement(FieldElement element) {
    //super.visitFieldElement(element);
    final annotation = element.metadata.firstWhere(
        (annotation) => _matchAnnotationType(DataField, annotation),
      orElse: () => null
    );
    if (annotation == null) return null;
    if (element.isPrivate) {
      log.severe(
          'Fields with the DataField annotation should be public: $element'
      );
      return null;
    }

    // Once valid, add the field element and the annotation to the map
    _dataFields[element] = annotation;
    return null;
  }
}

/*
 * Shameless copy of "matchAnnotation" function in AngularDart's
 * 'annotation_matcher.dart' file
 */
bool _matchAnnotationType(Type annotationType, ElementAnnotation annotation) {
  try {
    annotation.computeConstantValue();
    final checker = TypeChecker.fromRuntime(annotationType);
    final objectType = annotation.constantValue.type;
    return checker.isExactlyType(objectType);
  } catch (ex) {
    String message =
        'Could not resolve the type for annotation. It resolved to'
        '${annotation.constantValue}. Are you missing a dependency?';
    throw ArgumentError.value(
      annotation, 'annotation', message
    );
  }
}