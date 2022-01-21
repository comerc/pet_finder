# Pet Finder

Все любят котиков!

Если ты можешь помочь, ты должен помочь!

Pet project with Flutter + Firebase + Hasura.

![alt text](https://i.imgur.com/rIqziCQ.png)

## How to Start

```
$ flutter packages pub run build_runner build --delete-conflicting-outputs
```

for VSCode Apollo GraphQL

```
$ npm install -g apollo
```

create `./apollo.config.js`

```js
module.exports = {
  client: {
    includes: ['./lib/**/*.dart'],
    service: {
      name: '<project name>',
      url: '<graphql endpoint>',
      // optional headers
      headers: {
        'x-hasura-admin-secret': '<secret>',
        'x-hasura-role': 'user',
      },
      // optional disable SSL validation check
      skipSSLValidation: true,
      // alternative way
      // localSchemaFile: './schema.json',
    },
  },
}
```

how to download `schema.json` for `localSchemaFile`

```
$ apollo schema:download --endpoint <graphql endpoint> --header 'X-Hasura-Admin-Secret: <secret>' --header 'X-Hasura-Role: user'
```

## 👨‍🎨 Inspiration

- https://github.com/gerfagerfa/pet_finder
- https://github.com/comerc/flutter_idiomatic

Hope you guys enjoy it !  
:wave::wave::wave:

## Contacts

- E-Mail: [andrew.kachanov@gmail.com](mailto:andrew.kachanov@gmail.com)
- Telegram: [@AndrewKachanov](https://t.me/AndrewKachanov)

## Support Me

- [Patreon](https://www.patreon.com/comerc)
- [QIWI](https://donate.qiwi.com/payin/comerc)

## More Info

Это выпускная работа моих курсов по Flutter. Набрал группу учеников, мы занимались 3 месяца (всю осень 2020). Преследовал цель прокачать пробелы - учитель учится у своих учеников. Теперь умею готовить идиоматичный код, написал заметку: https://habr.com/ru/post/528106/

Как промежуточный этап для основного проекта, смотрите https://github.com/comerc

😺 We love cats!

## Manifest v2

- Преемственность к v1 - вёрстка и state management
- Переиспользование minsk8 - картография, animation, flutter_candies
- Применение нароботок flutter_idiomatic - соглашения и тесты (Unit, Widget, Integration)
- Концепция "from zero to hero" - от нового branch-а к релизу на FlutterFlow & Hasura
- Релизы: iOS, Android, FlutterWeb, SEO-web, telegram-bot, админка (отдельно), комьюнити (discourse.org)
- Вовлечённость: не животные, а питомцы; не пользователи, а соучастники
- Фокус: поиск дома для бездомных питомцев (и ничего более)
- Функционал:
  - лента питомцев
  - блог питомца
  - избранное
  - фасетный поиск (с отрицанием)
  - категории (таксономия)
  - гео-поиск
  - роли: волонтёр, хозяин, модератор, администратор
  - аутентификация и профиль для соучастников
  - top волонтёров (с защитой от читерства - только пристроенные питомцы)
  - лента новых постов в блогах питомцев - 15 минут славы Энди Уорхола
  - личная переписка между волонтёром и хозяином с формализацией диалога
  - настройки приложения
- OpenSource
- API (расширяемость)
- Защита от форка (приложений и данных)
- Промо: Habr, Dev.to, Hasura-Blog, FlutterFlow-Blog, ProductHunt, Kickstarter, YouTube-каналы
- Посевной сарафан через гиков ("все любят котиков")
- Сбор и анализ данных для A/B и CI
