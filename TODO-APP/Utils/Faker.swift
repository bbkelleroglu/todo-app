import Fakery

class FakerTodos {
    func fakeTodoGenerator() -> TodoModel {
        let faker = Faker()
        let todoItem = TodoModel(title: faker.lorem.words(amount: 3),
                                 description: faker.lorem.paragraphs(amount: 1),
                                 tags: [faker.lorem.words(amount: 1)],
                                 date: Date() + faker.number.randomDouble(), completed: faker.number.randomBool())
        return todoItem
    }
}
