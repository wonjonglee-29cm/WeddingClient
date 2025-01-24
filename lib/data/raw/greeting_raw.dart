class GreetingRaw {
  final int id;
  final String message;

  GreetingRaw({required this.id, required this.message});

  Map<String, dynamic> toJson() => {
        'id': id,
        'message': message,
      };
}
