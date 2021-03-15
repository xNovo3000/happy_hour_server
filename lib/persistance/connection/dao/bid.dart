import '../../model/auction.dart';
import '../../model/bid.dart';
import '../../model/user.dart';
import '_base.dart';

abstract class BidDao implements BaseDao<Bid> {

	List<Bid> getFromUser(User? user);

	List<Bid> getFromAuction(Auction? auction);

}