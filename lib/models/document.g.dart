// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DocumentAdapter extends TypeAdapter<Document> {
  @override
  final int typeId = 0;

  @override
  Document read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Document(
      fields[0] as String,
      fields[7] as String?,
      fields[1] as String,
      fields[2] as int,
      fields[3] as DocumentType,
      fields[4] as String,
      programmingLang: fields[5] as String?,
    )..lastReadPageNo = fields[6] as int?;
  }

  @override
  void write(BinaryWriter writer, Document obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.totalPageNum)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.uri)
      ..writeByte(5)
      ..write(obj.programmingLang)
      ..writeByte(6)
      ..write(obj.lastReadPageNo)
      ..writeByte(7)
      ..write(obj.authorName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DocumentTypeAdapter extends TypeAdapter<DocumentType> {
  @override
  final int typeId = 1;

  @override
  DocumentType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DocumentType.pdf;
      case 1:
        return DocumentType.epub;
      case 2:
        return DocumentType.txt;
      default:
        return DocumentType.pdf;
    }
  }

  @override
  void write(BinaryWriter writer, DocumentType obj) {
    switch (obj) {
      case DocumentType.pdf:
        writer.writeByte(0);
        break;
      case DocumentType.epub:
        writer.writeByte(1);
        break;
      case DocumentType.txt:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
