part of 'product_cubit.dart';

enum ProductStatus { initial, success, failed, empty, loading, loadmore }

class ProductState extends Equatable {
  final String message;
  final List<Product> products;
  final ProductStatus status;
  final int page;
  final bool isLoadingMore;

  const ProductState(
      {
        this.isLoadingMore = false,
        this.page = 1,
        this.message = "",
      this.products = const [],
      this.status = ProductStatus.initial});


   int get count => products.length;   
   int get nextPage => page + 1;

  
   ProductState loading() => copyWith(status: ProductStatus.loading);
     
   ProductState success() => copyWith(status: ProductStatus.success);

   ProductState failure() => copyWith(status: ProductStatus.failed);

    ProductState empty() => copyWith(status: ProductStatus.empty);


  ProductState copyWith(
      {int? page, String? message, List<Product>? products, ProductStatus? status, bool? isLoadingMore}) {
    return ProductState(
       isLoadingMore: isLoadingMore ?? this.isLoadingMore,
       page: page ?? this.page,
        message: message ?? this.message,
        products: products ?? this.products,
        status: status ?? this.status);
  }

  ProductState append(List<Product> products){
    return copyWith(
    status: ProductStatus.success,
    page: nextPage,
    products: [...this.products, ...products]
    );
  }

  ProductState refresh(List<Product> products){
    return copyWith(
      status: ProductStatus.success,
      page: 1,
      products: products
    );
  }
   


  @override
  List<Object?> get props => [message, products, status, page];
}
