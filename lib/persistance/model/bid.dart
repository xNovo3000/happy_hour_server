import '../connection/factory.dart';
import '_entity.dart';
import 'auction.dart';
import 'user.dart';

class Bid extends Entity {

	Bid(this.id, this.auction, this.user, this.amount);

	factory Bid.fromServer(final Map<String, dynamic> map) => Bid(
		map['ID'],
		DaoFactory.instance.auctionDao.get(map['AuctionID'])!,
		DaoFactory.instance.userDao.getFromInitial(map['UserInitial'])!,
		map['Amount']
	);

	factory Bid.fromJson(final Map<String, dynamic> map) => Bid(
		map['ID'],
		DaoFactory.instance.auctionDao.get(map['AuctionID'])!,
		DaoFactory.instance.userDao.getFromInitial(map['UserInitial'])!,
		map['Amount']
	);

	int id;
	Auction auction;
	User user;
	double amount;

	List<String> get primaryKeys => <String>['ID'];
	List<dynamic> get primaryValues => [id];
	
	List<String> get keys => <String>['AuctionID', 'UserInitial', 'Amount'];
	List<dynamic> get values => [auction.id, user.initial, amount];

	@override bool operator ==(Object o) => o is User ? o.id == id : false;
	@override int get hashCode => id.hashCode;
	@override String toString() => toJson().toString();

}