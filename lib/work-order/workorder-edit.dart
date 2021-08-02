import 'package:flutter/material.dart';

class WorkOrderEdit extends StatefulWidget {
  final snapshot;
  final int index;
  const WorkOrderEdit({Key? key, required this.snapshot, required this.index})
      : super(key: key);

  @override
  _WorkOrderEditState createState() =>
      _WorkOrderEditState(this.index, this.snapshot);
}

// ORDERID - AUFNR - char12
// SHORTTEXT - AUFTEXT - char40
// ORDERTYPE - AUFART - char4
// PR - QMART - char2 => B1 | B2 | B3 | BM | M1 | M2 | M3 | PA | PM | PN
// PRIORITY - PRIOK - char1 => 1 | 2 | 3 | 4
// DESCRIPTION - LTXA1 - char40
// DURATION - ARBEIT - int7
// EQUIPMENT - EQUNR - char18
// MATQTY - CO_MENGE - int13
// RESERVE - RSNUM - int10


// PRIORITY TYPE => CM | G0 | PM | QM | SL | SM | SR

class _WorkOrderEditState extends State<WorkOrderEdit> {
  final index;
  final snapshot;
  final _formKey = GlobalKey<FormState>();
  final form = {};
  late bool loading = false;

  _WorkOrderEditState(this.index, this.snapshot);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Hero(
        tag: 'item$index',
        child: Scaffold(
          appBar: AppBar(
            title: Text('Edit Work Order'),
          ),
          body: DefaultTextStyle.merge(
            style: TextStyle(color: Colors.grey[850]),
            child: Container(
              color: Colors.white,
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          'Work Order ID: ${snapshot.data[index]['ORDERID']}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          readOnly: true,
                          initialValue: snapshot.data[index]['ORDERID'],
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Work Order ID is required';
                            form['id'] = value;
                            return null;
                          },
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Work Order Id',
                            labelStyle: new TextStyle(
                              color: const Color(0xFF424242),
                              fontWeight: FontWeight.w300,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Work Order ID is required';
                            form['id'] = value;
                            return null;
                          },
                          style: TextStyle(
                            color: Colors.grey[850],
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Label text',
                            labelStyle: new TextStyle(
                              color: const Color(0xFF424242),
                              fontWeight: FontWeight.w200,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Work Order ID is required';
                            form['id'] = value;
                            return null;
                          },
                          style: TextStyle(
                            color: Colors.grey[850],
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Label text',
                            labelStyle: new TextStyle(
                              color: const Color(0xFF424242),
                              fontWeight: FontWeight.w200,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Work Order ID is required';
                            form['id'] = value;
                            return null;
                          },
                          style: TextStyle(
                            color: Colors.grey[850],
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Label text',
                            labelStyle: new TextStyle(
                              color: const Color(0xFF424242),
                              fontWeight: FontWeight.w200,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Work Order ID is required';
                            form['id'] = value;
                            return null;
                          },
                          style: TextStyle(
                            color: Colors.grey[850],
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Label text',
                            labelStyle: new TextStyle(
                              color: const Color(0xFF424242),
                              fontWeight: FontWeight.w200,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Work Order ID is required';
                            form['id'] = value;
                            return null;
                          },
                          style: TextStyle(
                            color: Colors.grey[850],
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Label text',
                            labelStyle: new TextStyle(
                              color: const Color(0xFF424242),
                              fontWeight: FontWeight.w200,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Work Order ID is required';
                            form['id'] = value;
                            return null;
                          },
                          style: TextStyle(
                            color: Colors.grey[850],
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Label text',
                            labelStyle: new TextStyle(
                              color: const Color(0xFF424242),
                              fontWeight: FontWeight.w200,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Work Order ID is required';
                            form['id'] = value;
                            return null;
                          },
                          style: TextStyle(
                            color: Colors.grey[850],
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Label text',
                            labelStyle: new TextStyle(
                              color: const Color(0xFF424242),
                              fontWeight: FontWeight.w200,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Work Order ID is required';
                            form['id'] = value;
                            return null;
                          },
                          style: TextStyle(
                            color: Colors.grey[850],
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Label text',
                            labelStyle: new TextStyle(
                              color: const Color(0xFF424242),
                              fontWeight: FontWeight.w200,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Work Order ID is required';
                            form['id'] = value;
                            return null;
                          },
                          style: TextStyle(
                            color: Colors.grey[850],
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Label text',
                            labelStyle: new TextStyle(
                              color: const Color(0xFF424242),
                              fontWeight: FontWeight.w200,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Visibility(
                          // visible: !loading,
                          child: MaterialButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  loading = true;
                                });
                              }
                              print(form);
                            },
                            child: Text('Submit'),
                            height: 50,
                            minWidth: double.infinity,
                            color: Colors.white,
                            textColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(50),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
