class Activity {
  String nombre;
  String descripcion;
  String imagen;
  double precio;
  int rating;
  List<String> comments;
  int idActividad;

  Activity({
    required this.idActividad,
    required this.nombre,
    required this.descripcion,
    required this.imagen,
    required this.precio,
    required this.rating,
    required this.comments,
  });

  factory Activity.fromJson(Map<String, dynamic> json, int idActividad) {
    return Activity(
        nombre: json['nombre'] ?? '',
        descripcion: json['descripcion'] ?? '',
        imagen: json['imagen'] ?? '',
        precio: (json['precio'] ?? 0).toDouble(),
        rating: 0,
        comments: [],
        idActividad: idActividad);
  }
}