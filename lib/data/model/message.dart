import 'package:objectbox/objectbox.dart';
import 'package:travel_planner/data/model/conversation.dart';

@Entity()
class ObjMessage {
  @Id()
  int id = 0;

  String text;
  @Property(type: PropertyType.date)
  DateTime createdAt;
  String sentBy;

  final conversation = ToOne<ObjConversation>();

  ObjMessage(
      {required this.text, required this.createdAt, required this.sentBy});
}
