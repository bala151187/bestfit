import 'package:flutter/material.dart';
import '../dummy-data.dart';

class MealDetailScreen extends StatelessWidget {
  static const routeName = '/meal-detail';

  final Function toggleFavorite;
  final Function isFavorite;

  MealDetailScreen(this.toggleFavorite, this.isFavorite);

  Widget buildSectionTitle(BuildContext context, String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.title,
      ),
    );
  }

  Widget buildContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      height: 150,
      width: 300,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mealId = ModalRoute.of(context).settings.arguments as String;
    final selectedMeals = DUMMY_MEALS.firstWhere((meal) => meal.id == mealId);
    return Scaffold(
      appBar: AppBar(
        title: Text('${selectedMeals.title}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                selectedMeals.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            buildSectionTitle(context, 'Ingredients'),
            buildContainer(
              ListView.builder(
                itemCount: selectedMeals.ingredients.length,
                itemBuilder: (ctx, index) => Card(
                  color: Theme.of(context).accentColor,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    child: Text(
                      selectedMeals.ingredients[index],
                    ),
                  ),
                ),
              ),
            ),
            buildSectionTitle(context, 'Steps'),
            buildContainer(ListView.builder(
              itemBuilder: (ctx, index) => Column(children: [
                ListTile(
                  leading: CircleAvatar(
                    child: Text('#${(index + 1)}'),
                  ),
                  title: Text(
                    selectedMeals.steps[index],
                  ),
                ),
                Divider(),
              ]),
              itemCount: selectedMeals.steps.length,
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(isFavorite(mealId) ? Icons.star : Icons.star_border),
        onPressed: () => toggleFavorite(mealId),
      ),
    );
  }
}
