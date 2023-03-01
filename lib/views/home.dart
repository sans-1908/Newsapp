import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:random/helper/data.dart';
import 'package:random/models/category_model.dart';
import 'package:random/views/article_views.dart';
import 'package:random/views/category_news.dart';
import '../models/article_model.dart';
import '../helper/news.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<CategoryModel> categories= <CategoryModel>[];
  List<ArticleModel> articles= <ArticleModel>[];
  bool _loading=true;
  @override
  void initState() {
    super.initState();
    categories=getCategories();
    getNews();
  }

  getNews() async{
    News newsClass=News();
    await newsClass.getNews();
    articles=newsClass.news;
    setState(() {
      _loading=false;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Flutter',style: TextStyle(
              color: Colors.black,
            ),),
            Text('News',style: TextStyle(
              color: Colors.blue,
            ),
            ),
          ],
        ),
        elevation: 0.0,
      ),
      body:_loading ? Center(
        child: Container(
          child:CircularProgressIndicator(),),
      )
        : SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              //categories
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                height: 70,
                child: ListView.builder(
                  itemCount: categories.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return CategoryTile(
                      imageUrl: categories[index].imageUrl,
                      categoryName: categories[index].categoryName,
                    );
                  },
                  ) 
                ),
        
                //blogs
                Container(
                  padding: EdgeInsets.only(top: 16),
                  child: ListView.builder(
                    itemCount: articles.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemBuilder:((context, index) {
                      return Blogtile(
                      imageUrl: articles[index].urlToImage,
                       title: articles[index].title, 
                       desc:articles[index].description,
                       url: articles[index].url,
                       )
                       ;
                    }) 
                  ),
                )
            ],
          ),
              ),
        ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  
  final String imageUrl,categoryName;
  CategoryTile({required this.imageUrl,required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context)=>CategoryNews(category: categoryName.toLowerCase())
        ));
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                imageUrl:imageUrl,width: 120,height:60,fit: BoxFit.cover,)),
            Container(
              alignment: Alignment.center,
              width: 120,height:60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                 color: Colors.black26,
              ),
              child: Text(categoryName,style: TextStyle(
                color: Colors.white,
              ),),
            )
          ],
        ),
      ),
    );
  }
}

class Blogtile extends StatelessWidget {
  final String imageUrl,title,desc,url;
  Blogtile({required this.imageUrl,required this.title,required this.desc,required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
      MaterialPageRoute(
        builder: (context)=>ArticleView(
        blogUrl: url,
        )
        ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(imageUrl)),
            Text(title,style:TextStyle(
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            )),
            SizedBox(
              height: 8,
            ),
            Text(desc,style: TextStyle(
              color: Colors.black54,
            ),),
          ],
        ),
      ),
    );
  }
}