// ignore_for_file: require_trailing_commas
import 'package:graphql/client.dart';

// TODO: https://github.com/apollographql/apollo-tooling/issues/1365

// публично для тестирования
mixin API {
  static final fetchNewUnitNotification = gql(r'''
    subscription FetchNewUnitNotification {
      units(
        order_by: {created_at: desc},
        limit: 1
      ) {
        id
      }
    }
  ''');

  static final upsertMember = gql(r'''
    mutation UpsertMember($display_name: String $image_url: String) {
      insert_member_one(object: {display_name: $display_name, image_url: $image_url}, 
      on_conflict: {constraint: member_pkey, update_columns: [display_name, image_url]}) {
        ...MemberFields          
      }
    }
  ''');

  static final upsertWish = gql(r'''
    mutation UpsertWish($unit_id: uuid!, $value: Boolean!) {
      insert_wish_one(object: {unit_id: $unit_id, value: $value},
      on_conflict: {constraint: wish_pkey, update_columns: [value]}) {
        unit {
          ...UnitFields
        }
      }
    }
  ''');

  static final readWishes = gql(r'''
    query ReadWishes {
      wishes(
        order_by: {updated_at: desc}
      ) {
        unit {
          ...UnitFields
        }
      }
    }
  ''');

  // static final createUnit = gql(r'''
  //   mutation CreateUnit(
  //     $breed_id: uuid!,
  //     $color: String!,
  //     $weight: Int!,
  //     $story: String!,
  //     $image_url: String!,
  //     $condition: condition_enum!,
  //     $birthday: date!,
  //     $address: String!,
  //   ) {
  //     insert_unit_one(object: {
  //       breed_id: $breed_id,
  //       color: $color,
  //       weight: $weight,
  //       story: $story,
  //       image_url: $image_url,
  //       condition: $condition,
  //       birthday: $birthday,
  //       address: $address,
  //     }) {
  //       ...UnitFields
  //     }
  //   }
  // ''');

  static final readUnits = gql(r'''
    query ReadUnits($category: category_enum!, $offset: Int!, $limit: Int!) {
      units(
        where: 
          {category: {_eq: $category}}, 
        order_by: {updated_at: desc},
        offset: $offset, 
        limit: $limit
      ) {
        ...UnitFields
      }
    }
  ''');

  // static final readUnitsByQuery = gql(r'''
  //   query ReadUnitsByQuery($query: String!, $category_id: String, $limit: Int!) {
  //     units(
  //       where:
  //         {_and:
  //           [
  //             {_or:
  //               [
  //                 {breed: {name: {_ilike: $query}}},
  //                 {address: {_ilike: $query}},
  //               ]
  //             },
  //             {breed: {category_id: {_eq: $category_id}}},
  //           ]
  //         },
  //       order_by: {updated_at: desc},
  //       limit: $limit
  //     ) {
  //       ...UnitFields
  //     }
  //   }
  // ''');

  static final fragments = gql(r'''
    fragment MemberFields on member {
      id
      display_name
      image_url
      phone
      is_whatsapp
      is_viber
    }

    fragment UnitFields on unit {
      id
      member {
        ...MemberFields
      }
      images
      title
      sex
      birthday
      age
      weight
      size {
        id
        name
      }
      wool
      color {
        id
        name
      }
      story
      phone
      address
      total_wishes
    }
  ''');
}
