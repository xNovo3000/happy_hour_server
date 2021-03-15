import '../../model/auction.dart';
import '_base.dart';

abstract class AuctionDao implements BaseDao<Auction> {
	
	List<Auction> getAfterDate(DateTime? date);

}