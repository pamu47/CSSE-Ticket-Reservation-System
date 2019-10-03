import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Ticket extends StatefulWidget {
  String docId,trip,cost,numberOfTickets;

  Ticket(this.docId,this.trip,this.cost,this.numberOfTickets);

  @override
  State<StatefulWidget> createState() {
    return TicketState();
  }
}

class TicketState extends State<Ticket> {
  
  String getQRdata(){
    String data = '${widget.docId}\n${widget.trip}\n${widget.cost}\n${widget.numberOfTickets}';
    return data;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket'),
      ),
      body: Center(
        child: Hero(
          tag: 'ticket',
          child: QrImage(
            data: getQRdata(),
            version: QrVersions.auto,
            size: 150.0,
          ),
        ),
      ),
    );
  }
}
