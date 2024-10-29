import 'dart:async';
import 'package:flutter/material.dart';
import 'package:prueba_simpleagri/controlador/terrenos.dart';
import 'package:prueba_simpleagri/model/terrenos.dart';
import 'package:prueba_simpleagri/view/menu.dart';
import 'package:prueba_simpleagri/widgets/Dialogo.dart';
import 'package:prueba_simpleagri/widgets/button_pill.dart';
import 'package:prueba_simpleagri/widgets/header.dart';

class Terreno extends StatefulWidget {
  @override
  _TerrenoState createState() => _TerrenoState();
}

class _TerrenoState extends State<Terreno> {

  bool loading = true, showHistory = false;
  late String system, user, dateDownload;
  int historyCount = 0;
  String history = '';
  TextEditingController controler_texto_busqueda = TextEditingController();
  ControladorTerrenos controllerterreno = ControladorTerrenos();
  List<ObjetoTerreno> lista_data = [];
  int _selectedIndex = 0;
  final List<String> _options = [ "Todos", 'Activo', 'Inactivo', 'Cerrado' ];
  List<ObjetoTerreno> lista_data_aux = [];

  @override
  void initState() {
    Timer(  Duration(seconds: 1), () => { cargar_tabla() } );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> cargar_tabla() async {

    lista_data = await controllerterreno.listadoTabla( context: context);

    setState(() {
        loading = false;
        lista_data_aux = lista_data;
    });
    
  }


  Future<void> _search() async {
    

    if ( controler_texto_busqueda.text.isEmpty ) {

      Dialogo().showAlert(context,"Por favor ingrese un texto para la busqueda");

    } else {

      //aqui realizar lo necesario para limpiar la lista y obtener los registros nuevos 

      lista_data.clear();

      lista_data = await controllerterreno.consultar( context: context, texto_busqueda: controler_texto_busqueda.text );
      
      setState(() { });
    
    }
  }

  Future<void> cambio_estado( int parameter) async {

    
    
    if(parameter == 3){
      lista_data = lista_data_aux;
    }
    else{

      
      List<ObjetoTerreno> lista_data_cargue = [];
      lista_data_aux.forEach((element) {

        int value = int.parse( element.status );
        if(  value == parameter){
          lista_data_cargue.add(element);
        }
      });

      lista_data = lista_data_cargue;
      
    }
    setState(() { });

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Header(
          text: 'Terreno',
          back: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      drawer: Menu(),
      body:  loading == true
          ? const Center(child: CircularProgressIndicator())
          :ListView(
              padding: const EdgeInsets.all(12.0),
              children: [

                TextFormField(
                  controller: controler_texto_busqueda,
                  obscureText:  false,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Texto Busqueda",
                    hintText: "Texto Busqueda",
                  ), ),
                SizedBox(height: 20),
                ButtonPill(
                  text: 'Buscar',
                  onPressed: () async {
                    _search();
                  },
                ),
                ButtonPill(
                  text: 'Limpíar filtro',
                  onPressed: () async {
                    cargar_tabla();
                  },
                ),
                SizedBox(height: 20),

                Center( 
                  child:
                  ToggleButtons(
                    isSelected: List.generate(_options.length, (index) => index == _selectedIndex),
                    onPressed: (int index) {

                      //realiza una funcion que se llame ( cambio_estado ) que tenga un parametro que reciba el valor de (index)
                      //debe realizar  una lista auxiliar para que pueda contener los datos originales y los datos de la busqueda
                      //recuerden que el estado "Todos" no exite entonces debe aplicar algo para que la tabla cargue todos los registros de nuevo
                      //estos registros se evaluan sobre temporales aqui no hay webservices.
                      int parameter = 0;
                      switch(index){
                        case 0:
                          parameter = 3; //todos
                          break;
                        case 1:
                          parameter = 0; //activos
                          break;
                        case 2:
                          parameter = 1; //inactivos
                          break;
                        case 3:
                          parameter = 2; //cerrado
                          break;
                      }
                      cambio_estado( parameter );
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    children: _options.map( (String label) =>  Row( children: [ SizedBox(width: 10),Text(label),SizedBox(width: 10) ], )  ).toList(),
                  ) ,
                ),

                //titulo de la tabla
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.centerLeft,
                  color: Colors.lightGreen,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      " Resultados Tabla ",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                //tabla  del proyecto
                SingleChildScrollView( 
                  scrollDirection: Axis.horizontal,
                  child: 
                DataTable(
                  decoration:  BoxDecoration(
                    borderRadius: BorderRadius.circular(20),  // this only make bottom rounded and not top
                    color: Color.fromARGB(230, 229, 231, 230),
                  ),
                  columns: const [ 
                          DataColumn(
                              label: Text("Terreno"),
                              numeric: false,
                          ),
                          DataColumn(
                              label: Text("Codigo"),
                              numeric: false,
                          ),
                          DataColumn(
                              label: Text("Estado"),
                              numeric: false,
                          ),
                          DataColumn(
                              label: Text("Fecha"),
                              numeric: false,
                          ),
                        ],
                  rows: lista_data.map(
                    (regt) => DataRow(
                              cells: [
                                  DataCell(
                                    Text( '${regt.terrain}'),
                                                  ),
                                  DataCell(
                                    Text('${regt.crop}'),
                                                  ),
                                  DataCell(
                                    Text('${regt.texto_status}'),
                                                ),
                                  DataCell(
                                    Text('${regt.creation_stamp}'),
                                  ),
                                ]),
                    ) .toList(),
                )
, )



              ],
            ),
    );
  }
}