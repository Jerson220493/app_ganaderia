import 'package:app_ganaderia/app/data/services/local/localDb.dart';
import 'package:app_ganaderia/app/domain/repositories/categories_repository.dart';

class CategoriesRepositoryImp implements CategoriesRepository {
  @override
  Future getCategoriesData() async {
    final categories = await LocalDatabase().readAllCategories();
    return categories;
  }

  @override
  Future<int> insertCategory(name) async {
    int result = await LocalDatabase().insertCategory(name: name);
    return result;
  }

  @override
  Future<Map<String, dynamic>> getCategoryDataById(id) async {
    final data = await LocalDatabase().getCategoryById(id: id);
    return data;
  }

  @override
  Future<int> updateCategoryData(id, name) async {
    final res = await LocalDatabase().updateCategory(
      id: id,
      name: name,
    );
    return res;
  }

  @override
  Future deleteCategoryData(id) async {
    await LocalDatabase().deleteCategory(id: id);
  }
}
