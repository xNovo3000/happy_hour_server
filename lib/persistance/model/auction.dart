import '_entity.dart';

class Auction extends Entity {

	Auction(this.id, this.name, this.expires, this.imageName);

	factory Auction.fromServer(final Map<String, dynamic> map) => Auction(
		map['ID'], map['Name'], DateTime.fromMillisecondsSinceEpoch(map['Expires'], isUtc: true), map['ImageName']
	);

	factory Auction.fromJson(final Map<String, dynamic> map) => Auction(
		map['ID'] ?? -1, map['Name'], DateTime.fromMillisecondsSinceEpoch(map['Expires'], isUtc: true), ''
	);

	int id;
	String name, imageName;
	DateTime expires;

	Map<String, dynamic> toJson() => super.toJson()
		..remove('ImageName');

	List<String> get primaryKeys => <String>['ID'];
	List<dynamic> get primaryValues => [id];
	
	List<String> get keys => <String>['Name', 'Expires', 'ImageName'];
	List<dynamic> get values => [name, expires.millisecondsSinceEpoch, imageName];

	@override bool operator ==(Object o) => o is Auction ? o.id == id : false;
	@override int get hashCode => id.hashCode;
	@override String toString() => toJson().toString();

}