abstract class Entity {

	Map<String, dynamic> toJson() => Map<String, dynamic>.fromIterables(primaryKeys, primaryValues)
		..addAll(Map<String, dynamic>.fromIterables(keys, values));

	List<String> get primaryKeys;
	List<dynamic> get primaryValues;
	
	List<String> get keys;
	List<dynamic> get values;

}