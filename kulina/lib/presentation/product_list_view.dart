import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kulina/bloc/cubit/product_cubit.dart';
import 'package:kulina/shared/constants.dart';

class ProductListView extends StatelessWidget {
  const ProductListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

      DateTime _selectedDate;

    BlocProvider.of<ProductCubit>(context).init();


       Widget _buildGridList(ProductState state){

      
          final products = state.products;

      return Stack(
        children: 
          [
            
           GridView.builder(
                controller: BlocProvider.of<ProductCubit>(context).scrollController,
                        padding: const EdgeInsets.all(10),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            mainAxisExtent: 335,
                            crossAxisCount: 2),
                        physics: AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics()),
                        itemCount: products.length,
                        itemBuilder: (buildContext, index) {
                 
                          if (index < products.length) return Container(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CachedNetworkImage(
                                    imageBuilder: (context, imageProvider) => Container(
                                          height: 100,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                    imageUrl: products[index].image_url),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: greenColor),
                                  child: Text(
                                    "BARU",
                                    style: textBoldFont.copyWith(color: Colors.white),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  products[index].name,
                                  style: textBoldFont.copyWith(fontSize: 14),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  products[index].brand_name,
                                  style: textNormalFont.copyWith(color: Colors.grey),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  products[index].package_name,
                                  style: textNormalFont.copyWith(color: Colors.grey),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                RichText(
                                  text: TextSpan(
                                    text:
                                        ' ${formatCurrency.format(products[index].price)}',
                                    style: textBoldFont.copyWith(
                                        fontSize: 14, color: Colors.black),
                                    children: const <TextSpan>[
                                      TextSpan(
                                          text: 'Termasuk Ongkir',
                                          style:
                                              TextStyle(fontSize: 12, color: Colors.grey)),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side:  BorderSide(color: primaryColor,width: 2)
                                    ),
                                    onPressed: () {},
                                    child: Text(
                                      "Tambah ke Keranjang",
                                      style: textBoldFont.copyWith(color: primaryColor),
                                    ),
                                    
                                    )
                              ],
                            ));
                
                 
                         return Container();  
                 
                        }),
        

            if(state.status == ProductStatus.loadmore) Positioned(
              bottom: 0,
              child: Align(alignment: Alignment.bottomCenter,
               child: Center(child: CircularProgressIndicator()),),
            ),
        
            
           ]
      );
    }

   Widget _buildCalenderTimeLine(){
      return CalendarTimeline(
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(Duration(days: 365)),
              onDateSelected: (date) {
                // setState(() {
                //   _selectedDate = date;
                // });
              },
              leftMargin: 20,
              monthColor: Colors.white70,
              dayColor: Colors.teal[200],
              dayNameColor: Color(0xFF333A47),
              activeDayColor: Colors.white,
              activeBackgroundDayColor: Colors.redAccent[100],
              dotsColor: Color(0xFF333A47),
           
              locale: 'en',
            );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Products", style: textBoldFont.copyWith(color: Colors.black, fontSize: 18),),
        leading: BackButton(color: Colors.black,),
        backgroundColor: Colors.white,
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {

         if(state.status == ProductStatus.loading){
           return Center(child: CircularProgressIndicator(backgroundColor: primaryColor,color: Colors.pink,),);
         }

         if(state.status == ProductStatus.failed) {
           return Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [Center(child:
            Text("${state.message}")),   
              SizedBox(height: 20,),

              OutlinedButton(onPressed: (){
                 BlocProvider.of<ProductCubit>(context).fetchProducts();
              }, child: Text("Refresh"))
           
           ],
        
           
           );
         }

          return RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<ProductCubit>(context).fetchProducts(actionStatus: ActionStatus.refresh);
            },
            child: _buildGridList(state)
          );
        },
      ),
    );

 
  }
}
