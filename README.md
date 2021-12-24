# Pet Finder

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
