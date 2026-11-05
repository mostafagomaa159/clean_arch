class GraphQLDocuments {
  GraphQLDocuments._();

  static const String getProductDetail = r'''
    query GetProductDetail($sku: String!) {
      products(filter: { sku: { eq: $sku } }) {
        items {
          __typename
          id
          uid
          sku
          name
          description {
            html
          }
          short_description {
            html
          }
          brand_detail {
            name
            url_alias
            image
            small_image
          }
          custom_attributes {
            selected_attribute_options {
              attribute_option {
                uid
                label
                is_default
              }
            }
            entered_attribute_value {
              value
            }
            attribute_metadata {
              uid
              code
              label
              data_type
              is_system
              ui_input {
                ui_input_type
                is_html_allowed
              }
            }
          }
          product_labels {
            product_details_label_text
            product_details_label_image
            product_details_label_class
            product_details_label_position
            product_details_label_css_style
          }
          price_range {
            minimum_price {
              regular_price {
                value
                currency
              }
              final_price {
                value
                currency
              }
              discount {
                percent_off
                amount_off
              }
            }
            maximum_price {
              regular_price {
                value
                currency
              }
              final_price {
                value
                currency
              }
            }
          }
          price_tiers {
            quantity
            final_price {
              value
              currency
            }
            discount {
              percent_off
            }
          }
          special_price
          special_to_date
          image {
            url
            label
          }
          small_image {
            url
            label
          }
          thumbnail {
            url
            label
          }
          media_gallery {
            __typename
            url
            label
            position
            disabled
            ... on ProductVideo {
              video_content {
                media_type
                video_provider
                video_url
                video_title
                video_description
              }
            }
          }
          stock_status
          only_x_left_in_stock
          categories {
            uid
            name
            url_key
            url_path
          }
          rating_summary
          review_count
          reviews(pageSize: 5) {
            items {
              summary
              text
              nickname
              created_at
              average_rating
              ratings_breakdown {
                name
                value
              }
            }
            page_info {
              current_page
              page_size
              total_pages
            }
          }
          related_products {
            uid
            sku
            name
            thumbnail {
              url
            }
            price_range {
              minimum_price {
                final_price {
                  value
                  currency
                }
              }
            }
          }
          upsell_products {
            uid
            sku
            name
            thumbnail {
              url
            }
            price_range {
              minimum_price {
                final_price {
                  value
                  currency
                }
              }
            }
          }
          crosssell_products {
            uid
            sku
            name
            thumbnail {
              url
            }
            price_range {
              minimum_price {
                final_price {
                  value
                  currency
                }
              }
            }
          }
          country_of_manufacture
          ... on SimpleProduct {
            weight
          }
        }
      }
    }
  ''';

  static const String productsByBrand = r'''
    query ProductsByBrand($brandId: String!, $pageSize: Int!) {
      products(filter: { brand: { eq: $brandId } }, pageSize: $pageSize) {
        total_count
        items {
          uid
          sku
          name
          thumbnail {
            url
          }
          price_range {
            minimum_price {
              final_price {
                value
                currency
              }
            }
          }
        }
      }
    }
  ''';

  static const String searchBrands = r'''
    query SearchBrands($page: Int, $pageSize: Int, $q: String) {
      getBrands(page: $page, pageSize: $pageSize, q: $q) {
        brands {
          id
          image
          name
        }
        page_info {
          page_size
          current_page
          total_pages
          total_count
        }
      }
    }
  ''';

  static const String searchProducts = r'''
    query SearchProducts(
      $searchText: String!
      $pageSize: Int!
      $currentPage: Int!
      $filters: ProductAttributeFilterInput
    ) {
      products(
        search: $searchText
        pageSize: $pageSize
        currentPage: $currentPage
        filter: $filters
      ) {
        total_count
        items {
          id
          type_id
          name
          sku
          stock_status
          sellable_quantity
          webrotate_path
          webrotate_json
          image {
            url
          }
          price_range {
            minimum_price {
              regular_price {
                value
              }
              final_price {
                value
              }
            }
          }
          product_labels {
            product_details_label_text
            product_details_label_image
            product_details_label_class
            product_details_label_position
            product_details_label_css_style
          }
        }
      }
    }
  ''';

  static const String submitContactForm = r'''
    mutation SubmitContactForm(
      $name: String!
      $email: String!
      $comment: String!
      $telephone: String
    ) {
      contactUs(
        input: {
          name: $name
          email: $email
          comment: $comment
          telephone: $telephone
        }
      ) {
        status
      }
    }
  ''';

  static const String createEmptyCart = r'''
    mutation CreateEmptyCart {
      createEmptyCart
    }
  ''';

  static const String customerCart = r'''
    query CustomerCart {
      customerCart {
        id
      }
    }
  ''';

  static const String cartFragment = r'''
    fragment CartFields on Cart {
      id
      total_quantity
      itemsV2 {
        total_count
        items {
          id
          uid
          quantity
          product {
            name
            sku
            thumbnail {
              url
            }
            price_range {
              minimum_price {
                regular_price {
                  value
                  currency
                }
                final_price {
                  value
                  currency
                }
              }
            }
          }
          prices {
            price {
              value
              currency
            }
            row_total {
              value
              currency
            }
          }
        }
        page_info {
          page_size
          current_page
          total_pages
        }
      }
      prices {
        grand_total {
          value
          currency
        }
        subtotal_excluding_tax {
          value
          currency
        }
        subtotal_including_tax {
          value
          currency
        }
        discounts {
          label
          amount {
            value
            currency
          }
        }
        applied_taxes {
          label
          amount {
            value
            currency
          }
        }
      }
      selected_payment_method {
        code
        title
        purchase_order_number
        selected_option
      }
      shipping_addresses {
        firstname
        lastname
        street
        city
        postcode
        telephone
        region {
          code
          label
        }
        selected_shipping_method {
          carrier_code
          carrier_title
          method_code
          method_title
          amount {
            value
            currency
          }
          price_incl_tax {
            value
            currency
          }
        }
      }
    }
  ''';

  static const String getCartDetails =
      '''
    query GetCartDetails(\$cartId: String!) {
      cart(cart_id: \$cartId) {
        ...CartFields
      }
    }
    $cartFragment
  ''';

  static const String addSimpleProductsToCart =
      '''
    mutation AddSimpleProductsToCart(
      \$cartId: String!
      \$sku: String!
      \$quantity: Float!
    ) {
      addSimpleProductsToCart(
        input: {
          cart_id: \$cartId
          cart_items: [{ data: { sku: \$sku, quantity: \$quantity } }]
        }
      ) {
        cart {
          ...CartFields
        }
      }
    }
    $cartFragment
  ''';

  static const String removeItemFromCart =
      '''
    mutation RemoveItemFromCart(\$cartId: String!, \$cartItemId: Int!) {
      removeItemFromCart(
        input: { cart_id: \$cartId, cart_item_id: \$cartItemId }
      ) {
        cart {
          ...CartFields
        }
      }
    }
    $cartFragment
  ''';

  static const String updateCartItems =
      '''
    mutation UpdateCartItems(
      \$cartId: String!
      \$cartItemId: Int!
      \$quantity: Float!
    ) {
      updateCartItems(
        input: {
          cart_id: \$cartId
          cart_items: [{ cart_item_id: \$cartItemId, quantity: \$quantity }]
        }
      ) {
        cart {
          ...CartFields
        }
      }
    }
    $cartFragment
  ''';

  static const String setGuestEmailOnCart = r'''
    mutation SetGuestEmailOnCart($cartId: String!, $email: String!) {
      setGuestEmailOnCart(input: { cart_id: $cartId, email: $email }) {
        cart {
          email
        }
      }
    }
  ''';

  static const String getCountryRegions = r'''
    query GetCountryRegions($countryCode: String!) {
      country(id: $countryCode) {
        id
        available_regions {
          id
          code
          name
        }
      }
    }
  ''';

  static const String setShippingAddressesOnCart = r'''
    mutation SetShippingAddressesOnCart(
      $input: SetShippingAddressesOnCartInput!
    ) {
      setShippingAddressesOnCart(input: $input) {
        cart {
          shipping_addresses {
            firstname
            lastname
            street
            city
            postcode
            telephone
            region {
              label
              code
            }
          }
        }
      }
    }
  ''';

  static const String setBillingAddressOnCart = r'''
    mutation SetBillingAddressOnCart($input: SetBillingAddressOnCartInput!) {
      setBillingAddressOnCart(input: $input) {
        cart {
          billing_address {
            firstname
            lastname
            company
            street
            city
            postcode
            telephone
            region {
              code
              label
            }
            country {
              code
              label
            }
          }
        }
      }
    }
  ''';

  static const String getCartShippingMethods = r'''
    query GetCartShippingMethods($cartId: String!) {
      cart(cart_id: $cartId) {
        email
        shipping_addresses {
          available_shipping_methods {
            amount {
              value
              currency
            }
            available
            carrier_code
            carrier_title
            method_code
            method_title
            price_excl_tax {
              value
              currency
            }
            price_incl_tax {
              value
              currency
            }
          }
          selected_shipping_method {
            amount {
              value
              currency
            }
            carrier_code
            carrier_title
            method_code
            method_title
          }
        }
      }
    }
  ''';

  static const String setShippingMethodsOnCart = r'''
    mutation SetShippingMethodsOnCart(
      $cartId: String!
      $carrierCode: String!
      $methodCode: String!
    ) {
      setShippingMethodsOnCart(
        input: {
          cart_id: $cartId
          shipping_methods: [
            { carrier_code: $carrierCode, method_code: $methodCode }
          ]
        }
      ) {
        cart {
          shipping_addresses {
            selected_shipping_method {
              carrier_code
              method_code
            }
          }
        }
      }
    }
  ''';

  static const String getAvailablePaymentMethods = r'''
    query GetAvailablePaymentMethods($cartId: String!) {
      cart(cart_id: $cartId) {
        available_payment_methods {
          code
          title
          options {
            code
            name
            logo
          }
        }
      }
    }
  ''';

  static const String setPaymentMethodOnCart = r'''
    mutation SetPaymentMethodOnCart(
      $cartId: String!
      $code: String!
      $selectedOption: String
    ) {
      setPaymentMethodOnCart(
        input: {
          cart_id: $cartId
          payment_method: { code: $code, selected_option: $selectedOption }
        }
      ) {
        cart {
          selected_payment_method {
            code
            title
            selected_option
          }
        }
      }
    }
  ''';

  static const String placeOrder = r'''
    mutation PlaceOrder($cartId: String!) {
      placeOrder(input: { cart_id: $cartId }) {
        orderV2 {
          number
        }
        errors {
          message
          code
        }
      }
    }
  ''';
}
