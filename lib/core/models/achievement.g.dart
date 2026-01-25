// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AchievementAdapter extends TypeAdapter<Achievement> {
  @override
  final int typeId = 3;

  @override
  Achievement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Achievement(
      type: fields[0] as AchievementType,
      unlockedAt: fields[1] as DateTime,
      title: fields[2] as String,
      description: fields[3] as String,
      icon: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Achievement obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.unlockedAt)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.icon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AchievementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AchievementTypeAdapter extends TypeAdapter<AchievementType> {
  @override
  final int typeId = 2;

  @override
  AchievementType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AchievementType.firstEntry;
      case 1:
        return AchievementType.streak7Days;
      case 2:
        return AchievementType.streak30Days;
      case 3:
        return AchievementType.streak100Days;
      case 4:
        return AchievementType.progress25Percent;
      case 5:
        return AchievementType.progress50Percent;
      case 6:
        return AchievementType.progress75Percent;
      case 7:
        return AchievementType.goalReached;
      case 8:
        return AchievementType.consistency10Days;
      case 9:
        return AchievementType.consistency30Days;
      case 10:
        return AchievementType.consistency100Days;
      default:
        return AchievementType.firstEntry;
    }
  }

  @override
  void write(BinaryWriter writer, AchievementType obj) {
    switch (obj) {
      case AchievementType.firstEntry:
        writer.writeByte(0);
        break;
      case AchievementType.streak7Days:
        writer.writeByte(1);
        break;
      case AchievementType.streak30Days:
        writer.writeByte(2);
        break;
      case AchievementType.streak100Days:
        writer.writeByte(3);
        break;
      case AchievementType.progress25Percent:
        writer.writeByte(4);
        break;
      case AchievementType.progress50Percent:
        writer.writeByte(5);
        break;
      case AchievementType.progress75Percent:
        writer.writeByte(6);
        break;
      case AchievementType.goalReached:
        writer.writeByte(7);
        break;
      case AchievementType.consistency10Days:
        writer.writeByte(8);
        break;
      case AchievementType.consistency30Days:
        writer.writeByte(9);
        break;
      case AchievementType.consistency100Days:
        writer.writeByte(10);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AchievementTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
