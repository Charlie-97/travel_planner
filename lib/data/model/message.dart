import 'package:objectbox/objectbox.dart';
import 'package:travel_planner/data/model/conversation.dart';

@Entity()
class Message {
  @Id()
  int id = 0;

  String text;
  @Property(type: PropertyType.date)
  DateTime? createdAt;

  final conversation = ToOne<Conversation>();

  
  Message({required this.text, this.createdAt});
}
