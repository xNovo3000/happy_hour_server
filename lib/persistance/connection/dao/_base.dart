import '../../model/_entity.dart';

abstract class BaseDao<T extends Entity> {

	T? get(int? id);
	List<T> getAll();
	bool insert(T t);
	bool update(T t);
	bool delete(T t);
	int count();

}