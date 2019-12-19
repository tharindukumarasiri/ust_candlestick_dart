import 'package:flutter/material.dart';
import 'package:ust_candlestick/packages/bloc/klineBloc.dart';
import 'package:ust_candlestick/packages/klinePage.dart';
import 'package:http/http.dart' as http;
import 'package:ust_candlestick/example/kline_data_model.dart';
import 'package:ust_candlestick/packages/model/klineModel.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

void main() => runApp(MyApp());

Future<String> loadAsset() async {
  return await rootBundle.loadString('json/btcusdt.json');
}

Future<String> getIPAddress(String period) async {
  if (period == null) {
    period = '1day';
  }
  var url =
      'https://api.huobi.vn/market/history/kline?period=$period&size=449&symbol=btcusdt';
  String result;
  var response = await http.get(url);
  if (response.statusCode == HttpStatus.ok) {
    result = response.body;
  } else {
    print('Failed getting IP address');
  }
  return result;
}



class KlinePageBloc extends KlineBloc {
  @override
  void periodSwitch(String period) {
    _getData(period);
    super.periodSwitch(period);
  }

  @override
  void initData() {
    _getData('1day');
    super.initData();
  }

  _getData(String period) {
    this.showLoadingSinkAdd(true);
    Future<String> future = getIPAddress('$period');
    future.then((result) {
      final parseJson = json.decode(result);
      MarketData marketData = MarketData.fromJson(parseJson);
      List<Market> list = List<Market>();
      for (var item in marketData.data) {
        Market market =
            Market(item.open, item.high, item.low, item.close, item.vol,item.id);
        list.add(market);
      }
      this.showLoadingSinkAdd(false);
      this.updateDataList(list);
    });
  }
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'UST flutter Candle Stick chart'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    KlinePageBloc bloc = KlinePageBloc();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: 
                  Container(
              height: 500.0,
              child: KlinePageWidget(bloc),
            ),

    );
  }
}

