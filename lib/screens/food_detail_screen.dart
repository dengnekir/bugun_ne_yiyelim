import 'package:flutter/material.dart';
import '../models/food.dart';

class FoodDetailScreen extends StatelessWidget {
  final Food food;

  const FoodDetailScreen({Key? key, required this.food}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(food.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (food.imageUrl.isNotEmpty)
              Image.network(
                food.imageUrl,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 250,
                    color: Colors.grey[300],
                    child: const Icon(Icons.restaurant, size: 64),
                  );
                },
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    food.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(context),
                  const SizedBox(height: 24),
                  _buildSection(context, 'Malzemeler', food.ingredients),
                  const SizedBox(height: 24),
                  _buildSection(context, 'Hazırlanışı', food.recipe),
                  const SizedBox(height: 24),
                  _buildNutritionInfo(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildInfoItem(
            context, 'Hazırlama', '${food.preparationTime} dk', Icons.timer),
        _buildInfoItem(context, 'Kalori', '${food.calories} kcal',
            Icons.local_fire_department),
        _buildInfoItem(
            context, 'Porsiyon', '${food.servings} kişilik', Icons.people),
      ],
    );
  }

  Widget _buildInfoItem(
      BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }

  Widget _buildSection(BuildContext context, String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Theme.of(context).primaryColor)),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${index + 1}. ',
                      style: Theme.of(context).textTheme.bodyLarge),
                  Expanded(
                    child: Text(items[index],
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNutritionInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Besin Değerleri',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Theme.of(context).primaryColor)),
        const SizedBox(height: 8),
        _buildNutritionRow(context, 'Protein', '${food.protein}g'),
        _buildNutritionRow(context, 'Karbonhidrat', '${food.carbs}g'),
        _buildNutritionRow(context, 'Yağ', '${food.fat}g'),
        _buildNutritionRow(context, 'Lif', '${food.fiber}g'),
      ],
    );
  }

  Widget _buildNutritionRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
