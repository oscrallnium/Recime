//
//  PreviewHelper.swift
//  Recime
//
//  Created by Oscar Allen Brioso on 3/23/26.
//

import Foundation

// MARK: - Preview Data
// Static mock data for SwiftUI Previews.
// Keeps preview blocks clean and avoids loading JSON in canvas.

extension Recipe {

    static let previewFeatured = Recipe(
        id: "featured_001",
        title: "Summer Harvest Buddha Bowl with Tahini",
        description: "A vibrant, nutrient-packed bowl featuring roasted seasonal vegetables, quinoa, chickpeas, and a creamy lemon-tahini dressing.",
        image: "buddha_bowl",
        servings: 4,
        prepTimeMinutes: 25,
        calories: 420,
        rating: 4.9,
        isFeatured: true,
        dietaryAttributes: ["vegetarian", "vegan"],
        mood: ["healthy", "quick-meals"],
        ingredients: [
            Ingredient(name: "quinoa", amount: "1", unit: "cup"),
            Ingredient(name: "chickpeas", amount: "1", unit: "can"),
            Ingredient(name: "tahini", amount: "3", unit: "tbsp"),
        ],
        instructions: [
            Instruction(step: 1, title: "Cook the Quinoa", description: "Rinse quinoa and cook with 2 cups water for 15 minutes.", timerMinutes: 15),
            Instruction(step: 2, title: "Assemble", description: "Divide quinoa among bowls and add toppings.", timerMinutes: nil),
        ]
    )

    static let previewRecipes: [Recipe] = [
        Recipe(
            id: "recipe_001",
            title: "Mediterranean Orzo Salad",
            description: "A refreshing mix of kalamata olives, feta, and heirloom tomatoes tossed with perfectly cooked orzo.",
            image: "orzo_salad",
            servings: 4,
            prepTimeMinutes: 30,
            calories: 380,
            rating: 4.9,
            isFeatured: false,
            dietaryAttributes: ["vegetarian"],
            mood: ["healthy", "quick-meals"],
            ingredients: [
                Ingredient(name: "orzo pasta", amount: "1.5", unit: "cups"),
                Ingredient(name: "feta cheese", amount: "1/2", unit: "cup"),
            ],
            instructions: [
                Instruction(step: 1, title: "Cook the Orzo", description: "Boil orzo until al dente.", timerMinutes: 9),
            ]
        ),
        Recipe(
            id: "recipe_002",
            title: "Avocado & Poached Egg Toast",
            description: "Perfectly sourdough base topped with crushed avocado, a silky poached egg, and chili flakes.",
            image: "avocado_toast",
            servings: 1,
            prepTimeMinutes: 15,
            calories: 310,
            rating: 4.7,
            isFeatured: false,
            dietaryAttributes: ["vegetarian"],
            mood: ["breakfast", "quick-meals"],
            ingredients: [
                Ingredient(name: "sourdough bread", amount: "2", unit: "slices"),
                Ingredient(name: "avocado", amount: "1", unit: "ripe"),
            ],
            instructions: [
                Instruction(step: 1, title: "Toast the Bread", description: "Toast until golden.", timerMinutes: 3),
            ]
        ),
        Recipe(
            id: "recipe_003",
            title: "Cloud-Light Buttermilk Pancakes",
            description: "Extra fluffy pancakes made with aged buttermilk and a touch of vanilla.",
            image: "buttermilk_pancakes",
            servings: 6,
            prepTimeMinutes: 25,
            calories: 290,
            rating: 5.0,
            isFeatured: false,
            dietaryAttributes: ["vegetarian"],
            mood: ["breakfast"],
            ingredients: [
                Ingredient(name: "buttermilk", amount: "1.25", unit: "cups"),
            ],
            instructions: [
                Instruction(step: 1, title: "Mix", description: "Combine dry ingredients.", timerMinutes: nil),
            ]
        ),
        Recipe(
            id: "recipe_004",
            title: "Wild Mushroom Pappardelle",
            description: "Handmade pasta tossed with sautéed forest mushrooms, thyme, garlic, and white wine cream.",
            image: "mushroom_pappardelle",
            servings: 2,
            prepTimeMinutes: 40,
            calories: 520,
            rating: 4.8,
            isFeatured: false,
            dietaryAttributes: ["vegetarian"],
            mood: [],
            ingredients: [
                Ingredient(name: "pappardelle pasta", amount: "250", unit: "g"),
            ],
            instructions: [
                Instruction(step: 1, title: "Cook Pasta", description: "Boil until al dente.", timerMinutes: 8),
            ]
        ),
    ]
}

extension Mood {
    static let previewMoods: [Mood] = [
        Mood(id: "breakfast", name: "Breakfast", icon: "cup.and.saucer.fill"),
        Mood(id: "healthy", name: "Healthy", icon: "leaf.fill"),
        Mood(id: "quick-meals", name: "Quick Meals", icon: "bolt.fill"),
        Mood(id: "comfort", name: "Comfort Food", icon: "flame.fill"),
    ]
}
