import 'package:flutter/material.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/widgets/footer.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({super.key});

  final List<Map<String, dynamic>> recipes = const [
    {
      "name": "Cơm Chiên Hải Sản",
      "description": "Món cơm chiên thơm ngon kết hợp giữa tôm, mực và rau.",
      "prep_time_minutes": 15,
      "cook_time_minutes": 20,
      "servings": 4,
      "ingredients": [
        {"ingredient_name": "cơm", "quantity": 500, "unit_id": 2},
        {"ingredient_name": "tôm", "quantity": 200, "unit_id": 2},
        {"ingredient_name": "mực", "quantity": 150, "unit_id": 2},
        {"ingredient_name": "đậu", "quantity": 100, "unit_id": 2},
        {"ingredient_name": "cà rốt", "quantity": 1, "unit_id": 1},
        {"ingredient_name": "trứng", "quantity": 2, "unit_id": 1},
        {"ingredient_name": "hành", "quantity": 50, "unit_id": 2},
        {"ingredient_name": "nước tương", "quantity": 30, "unit_id": 2}
      ],
      "steps": [
        "Luộc tôm và mực, cắt nhỏ.",
        "Phi thơm hành, thêm tôm và mực vào xào.",
        "Thêm cà rốt, đậu, và cơm vào xào đều.",
        "Đánh trứng, đổ vào chảo và đảo đều.",
        "Nêm nước tương, rắc hành, và phục vụ nóng."
      ],
      "notes": "Có thể thêm ớt nếu thích ăn cay."
    },
    {
      "name": "Bánh Xèo",
      "description":
          "Món bánh truyền thống Việt Nam giòn rụm với nhân thịt, tôm và rau.",
      "prep_time_minutes": 20,
      "cook_time_minutes": 40,
      "servings": 4,
      "ingredients": [
        {"ingredient_name": "bột", "quantity": 400, "unit_id": 2},
        {"ingredient_name": "nước", "quantity": 200, "unit_id": 2},
        {"ingredient_name": "thịt", "quantity": 200, "unit_id": 2},
        {"ingredient_name": "tôm", "quantity": 150, "unit_id": 2},
        {"ingredient_name": "rau", "quantity": 200, "unit_id": 2},
        {"ingredient_name": "hành", "quantity": 50, "unit_id": 2}
      ],
      "steps": [
        "Trộn bột với nước, thêm hành.",
        "Chiên thịt và tôm.",
        "Đổ bột vào chảo, xoay đều.",
        "Thêm thịt, tôm và rau, gập đôi bánh.",
        "Chiên giòn và phục vụ với rau và nước chấm."
      ],
      "notes": "Dùng chảo chống dính để bánh giòn lâu hơn."
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: const Header(),
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe["name"],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(recipe["description"]),
                    const SizedBox(height: 8),
                    Text(
                        "Preparation Time: ${recipe["prep_time_minutes"]} minutes"),
                    Text("Cook Time: ${recipe["cook_time_minutes"]} minutes"),
                    Text("Servings: ${recipe["servings"]}"),
                    const SizedBox(height: 16),
                    const Text(
                      "Ingredients:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    for (var ingredient in recipe["ingredients"])
                      Text(
                          "- ${ingredient["ingredient_name"]}: ${ingredient["quantity"]}"),
                    const SizedBox(height: 16),
                    const Text(
                      "Steps:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    for (var step in recipe["steps"]) Text("- $step"),
                    const SizedBox(height: 16),
                    Text("Notes: ${recipe["notes"]}"),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const Footer(
        currentIndex: 3,
      ),
    );
  }
}
