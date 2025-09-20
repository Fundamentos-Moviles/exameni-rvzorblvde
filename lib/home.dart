import 'dart:math';
import 'package:flutter/material.dart';
import 'package:examenfdm_332508/constantes.dart' as cons;

/// Buscaminas

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const int filas = 6;
  static const int cols  = 6;
  static const int celdas = filas * cols;
  static const int bombas = 6; // nº de bombas (simple)

  late Set<int> _bombas;
  late List<bool> _revelada;   // que ya se esccogió la casilla
  bool _gameOver = false;
  bool _gano = false;

  @override
  void initState() {
    super.initState();
    _reiniciar();
  }

  void _reiniciar() {
    final rnd = Random();
    final set = <int>{};
    while (set.length < bombas) {
      set.add(rnd.nextInt(celdas));
    }
    _bombas = set;
    _revelada = List<bool>.filled(celdas, false);
    _gameOver = false;
    _gano = false;
    setState(() {});
  }

  void _tocar(int idx) {
    if (_gameOver || _revelada[idx]) return;

    setState(() {
      _revelada[idx] = true;

      if (_bombas.contains(idx)) {
        _gameOver = true; // Bomba pasa a rojo y termina
      } else {
        // Revisa si ya ganó
        final totalSeguras = celdas - _bombas.length;
        final reveladasSeguras = List.generate(celdas, (i) => i)
            .where((i) => _revelada[i] && !_bombas.contains(i))
            .length;
        if (reveladasSeguras == totalSeguras) {
          _gano = true;
          _gameOver = true; // finaliza al completar todas las verdes
        }
      }
    });
  }

  Color _colorCelda(int idx) {
    if (!_revelada[idx]) return cons.gris;
    if (_bombas.contains(idx)) return cons.rojoKO;
    return cons.verdeOK;
  }

  Widget _celda(int idx) {
    return Expanded(
      child: InkWell(
        onTap: () => _tocar(idx),
        child: Container(
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: _colorCelda(idx),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }

  /// Construye la cuadrícula con Expanded yb InkWell
  Widget _grid() {
    int k = 0;
    final filasWidgets = <Widget>[];
    for (int f = 0; f < filas; f++) {
      final filaCeldas = <Widget>[];
      for (int c = 0; c < cols; c++) {
        filaCeldas.add(_celda(k++));
      }
      filasWidgets.add(
        Expanded(child: Row(children: filaCeldas)),
      );
    }
    return Expanded(child: Column(children: filasWidgets));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cons.azulito,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              color: cons.azulito2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Buscaminas FDM',
                    style: TextStyle(color: cons.blanco, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Guillermo Jair Muñoz Amaro',
                    style: TextStyle(color: cons.blanco, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // reiniciar
                      InkWell(
                        onTap: _reiniciar,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: cons.azulito3,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.refresh, color: cons.blanco, size: 18),
                              SizedBox(width: 8),
                              Text('Reiniciar', style: TextStyle(color: cons.blanco)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _gameOver ? (_gano ? 'Completado' : 'Bomba! Juego terminado') : 'Toca una casilla…',
                          textAlign: TextAlign.right,
                          style: const TextStyle(color: cons.blanco),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Separador
            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cons.blanco,
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 420, // alto fijo para que el grid quede cuadrado
                child: _grid(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}