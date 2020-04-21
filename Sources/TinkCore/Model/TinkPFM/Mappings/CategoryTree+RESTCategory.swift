import Foundation

extension CategoryTree {
    init(restCategories: [RESTCategory]) {
        let categoriesByCode = Dictionary(grouping: restCategories, by: { $0.code }).compactMapValues({ $0.first })
        let categoriesByParentID = Dictionary(grouping: restCategories, by: { $0.parent ?? "_root" })

        if let restCategory = categoriesByCode["expenses"] {
            var node = CategoryTree.Node(restCategory: restCategory)
            for subcategory in categoriesByParentID[restCategory.id] ?? [] {
                var childNode = CategoryTree.Node(restCategory: subcategory)
                for subsubcategory in categoriesByParentID[subcategory.id] ?? [] {
                    let grandChildNode = CategoryTree.Node(restCategory: subsubcategory)
                    childNode.subcategories.append(grandChildNode)
                }
                childNode.subcategories.sort()
                node.subcategories.append(childNode)
            }
            node.subcategories.sort()
            expenses = node
        } else {
            expenses = nil
        }

        if let restCategory = categoriesByCode["income"] {
            var node = CategoryTree.Node(restCategory: restCategory)
            for subcategory in categoriesByParentID[restCategory.id] ?? [] {
                var childNode = CategoryTree.Node(restCategory: subcategory)
                for subsubcategory in categoriesByParentID[subcategory.id] ?? [] {
                    let grandChildNode = CategoryTree.Node(restCategory: subsubcategory)
                    childNode.subcategories.append(grandChildNode)
                }
                childNode.subcategories.sort()
                node.subcategories.append(childNode)
            }
            node.subcategories.sort()
            income = node
        } else {
            income = nil
        }

        if let restCategory = categoriesByCode["transfers"] {
            var node = CategoryTree.Node(restCategory: restCategory)
            for subcategory in categoriesByParentID[restCategory.id] ?? [] {
                var childNode = CategoryTree.Node(restCategory: subcategory)
                for subsubcategory in categoriesByParentID[subcategory.id] ?? [] {
                    let grandChildNode = CategoryTree.Node(restCategory: subsubcategory)
                    childNode.subcategories.append(grandChildNode)
                }
                childNode.subcategories.sort()
                node.subcategories.append(childNode)
            }
            node.subcategories.sort()
            transfers = node
        } else {
            transfers = nil
        }
    }
}
