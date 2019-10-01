import 'package:flutter/material.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';

class CreditAccount extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return CreditAccountState();
  }
}

class CreditAccountState extends State<CreditAccount>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Credits to your Account', style: TextStyle(fontFamily: 'Ubuntu'),),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addCard,
        tooltip: 'Add Card',
        child: Icon(Icons.credit_card),
      ),
    );
  }
  void addCard(){
    InAppPayments.setSquareApplicationId('sq0idp-ZAVv0dM1D29oHrTnKL9Ulw');
    InAppPayments.startCardEntryFlow(
      onCardNonceRequestSuccess: _cardNonceRequestSuccess,
      onCardEntryCancel: _cardEntryCancel
    );
  }
  void _cardEntryCancel(){}
  void _cardNonceRequestSuccess(CardDetails result){
    print('Card Data ::::: ${result.card}');
    InAppPayments.completeCardEntry(
      onCardEntryComplete: _cardEntryComplete 
    );
  }

  void _cardEntryComplete(){
    
  }
}