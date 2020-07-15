import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Employees(),
    );
  }
}

class Employees extends StatefulWidget {
  @override
  _EmployeesState createState() => _EmployeesState();
}

class _EmployeesState extends State<Employees> {
  PageController _controller = PageController(initialPage: 0,);

  getEmployees()async{
    String theUrl = 'http://demo8161595.mockable.io/employee';
    var res = await http.get(Uri.encodeFull(theUrl),headers:{"Accept":"application/json"});
    var responsBody = json.decode(res.body);
    print(responsBody);
    return responsBody;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title:Text("Employees") ,
      ),
      body:FutureBuilder(
        future: getEmployees(),
        builder: (BuildContext context , AsyncSnapshot snapshot){
          List snap = snapshot.data;
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.hasError){
            return Center(
              child: Text("Error .... "),
            );
          }

          return PageView.builder(
            itemCount: snap.length,
            itemBuilder: (context,index){
              return PageView(
                controller:_controller,
                children: snap.map((e) => employeePage(e,snap.length)).toList(),
              );
            },
          );
        },
      ),
    );
  }

  Widget employeePage(node , length)
  {
    return Container(
                    padding: EdgeInsets.all(5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: CircleAvatar(
                            radius: 50.0,
                            backgroundImage:
                            NetworkImage("${node['avatar']}"),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[

                              Text(
                                'Name',
                                style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,),
                              ),
                              SizedBox(height: 5.0),
                              Text("${node['firstName']}" + "  " + "${node['lastName']}",style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Email',
                                style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,),
                              ),
                              SizedBox(height: 5.0),
                              Text("${node['email']}",style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ),
                        SizedBox(height:5.0),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 20.0),
                              Center(
                                child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                  child:  Center(
                                    child:Container(
                                      child: RaisedButton.icon(
                                        onPressed: () {
                                          int page = _controller.page.toInt();
                                          _controller.animateToPage(page + 1 ,  duration: Duration(milliseconds: 500),curve: Curves.ease,);
                                          _controller.jumpToPage(page+1);
                                          if(_controller.page.toInt() == length)
                                          {
                                            Container(
                                              child: Center(
                                                child: Text("Last Page"),
                                              ),
                                            );
                                          }
                                        },
                                        color: Colors.teal,
                                        icon: Icon(Icons.navigate_next,color:Colors.white ,),
                                        label: Text("NEXT",style: TextStyle(color: Colors.white),),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
  }
}