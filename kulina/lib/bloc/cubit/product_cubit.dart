import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:kulina/model/product.dart';
import 'package:kulina/service/service.dart';

part 'product_state.dart';


enum ActionStatus{refresh, fecth}

class ProductCubit extends Cubit<ProductState> {
     
  ScrollController? scrollController;
  
  ProductCubit() : super(ProductState()){
    
    scrollController = ScrollController();

    scrollController?.addListener(() {
        if(scrollController!.offset >= scrollController!.position.maxScrollExtent && !scrollController!.position.outOfRange){
          loadMore();
        }
     });
  }


  void init() {
    fetchProducts();
  }


  Future<void> fetchProducts({ActionStatus actionStatus = ActionStatus.fecth}) async {
    
    emit(state.loading());

    int _page = actionStatus == ActionStatus.fecth ? state.page : 1;

    final result = await Service.getProduct(page: _page);

    return result.fold(
        (f) {
           print(f.message);
          emit(
         
            state.copyWith(message: f.message, status: ProductStatus.failed));
        },
        (r) {
      log(r.toString() + "bloc");

      if (r.isNotEmpty) {

       if(actionStatus == ActionStatus.fecth){

          emit(state.append(r));
       }else{
          emit(state.refresh(r));
       }

        emit(state.success());
      } else {
        state.empty();
      }

      emit(state.copyWith(status: ProductStatus.initial));
    });
  }


  Future<void> loadMore() async {
      emit(state.copyWith(status: ProductStatus.loadmore));

     await Service.getProduct(page: state.page).then((value){
      
       value.fold((f){
         emit(state.copyWith(message: f.message));
       }, (r){ 
         emit(state.append(r));
       });
     });
  } 

}
