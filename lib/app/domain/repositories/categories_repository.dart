abstract class CategoriesRepository {
  Future getCategoriesData();
  Future insertCategory(name);
  Future getCategoryDataById(id);
  Future updateCategoryData(id, name);
  Future deleteCategoryData(id);
}
