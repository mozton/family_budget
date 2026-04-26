import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewEntryScreen extends StatefulWidget {
  const NewEntryScreen({super.key});

  @override
  State<NewEntryScreen> createState() => _NewEntryScreenState();
}

class _NewEntryScreenState extends State<NewEntryScreen> {
  bool isExpense = true;
  String selectedCategory = 'Comida';
  bool isPrivate = false;

  // Colores de la paleta "Nuestra Bóveda"
  final Color primaryPurple = const Color(0xFF9333EA);
  final Color lilaPastel = const Color(0xFFA18CD1);
  final Color rosaPastel = const Color(0xFFFBC2EB);
  final Color incomeGreen = const Color(0xFF10B981);
  final Color expenseRed = const Color(0xFFF87171);

  final List<Map<String, dynamic>> expenseCategories = [
    {'id': 'Comida', 'emoji': '🥗', 'color': const Color(0xFFFFF7ED)},
    {'id': 'Hogar', 'emoji': '🏠', 'color': const Color(0xFFEFF6FF)},
    {'id': 'Ocio', 'emoji': '🎬', 'color': const Color(0xFFFAF5FF)},
    {'id': 'Transp.', 'emoji': '🚗', 'color': const Color(0xFFFEFCE8)},
    {'id': 'Salud', 'emoji': '🏥', 'color': const Color(0xFFFEF2F2)},
  ];

  final List<Map<String, dynamic>> incomeCategories = [
    {'id': 'Sueldo', 'emoji': '💰', 'color': const Color(0xFFF0FDF4)},
    {'id': 'Freelance', 'emoji': '💻', 'color': const Color(0xFFECFEFF)},
    {'id': 'Regalo', 'emoji': '🎁', 'color': const Color(0xFFFDF2F8)},
    {'id': 'Inversión', 'emoji': '📈', 'color': const Color(0xFFECFDF5)},
  ];

  List<Map<String, dynamic>> get currentCategories =>
      isExpense ? expenseCategories : incomeCategories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Nueva Entrada',
          style: GoogleFonts.quicksand(
            color: const Color(0xFF1F2937),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Toggle Gasto/Ingreso
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  _buildTypeButton("Gasto", true),
                  _buildTypeButton("Ingreso", false),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Input de Monto
            Text(
              "MONTO",
              style: GoogleFonts.quicksand(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey[500],
                letterSpacing: 1.2,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "\$",
                  style: GoogleFonts.quicksand(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: isExpense
                        ? expenseRed.withOpacity(0.5)
                        : incomeGreen.withOpacity(0.5),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 150,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.quicksand(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F2937),
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "0.00",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            // Grid de Categorías
            Text(
              "CATEGORÍA",
              style: GoogleFonts.quicksand(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey[500],
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 0.9,
              ),
              itemCount: currentCategories.length + 1,
              itemBuilder: (context, index) {
                if (index == currentCategories.length) {
                  return _buildAddCategoryButton();
                }
                final cat = currentCategories[index];
                return _buildCategoryItem(cat);
              },
            ),
            const SizedBox(height: 40),
            // Campo de Nota
            _buildCustomTextField("Nota", "¿En qué lo usaste?"),
            const SizedBox(height: 20),
            // Toggle Privado
            _buildPrivateToggle(),
            const SizedBox(height: 40),
            // Botón Registrar
            _buildSubmitButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton(String label, bool type) {
    bool active = isExpense == type;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (isExpense != type) {
            setState(() {
              isExpense = type;
              selectedCategory = isExpense
                  ? expenseCategories.first['id'] as String
                  : incomeCategories.first['id'] as String;
            });
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ]
                : [],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
              fontWeight: FontWeight.bold,
              color: active ? const Color(0xFF1F2937) : Colors.grey[400],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(Map<String, dynamic> cat) {
    bool isSelected = selectedCategory == cat['id'];
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = cat['id']!),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              color: cat['color'],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? primaryPurple.withOpacity(0.5)
                    : Colors.transparent,
                width: 2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: primaryPurple.withOpacity(0.1),
                        blurRadius: 10,
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: Text(cat['emoji']!, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            cat['id']!.toUpperCase(),
            style: GoogleFonts.quicksand(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isSelected ? const Color(0xFF1F2937) : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddCategoryButton() {
    return Column(
      children: [
        Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.grey[200]!,
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          child: Icon(Icons.add, color: Colors.grey[500]),
        ),
        const SizedBox(height: 8),
        Text(
          "NUEVA",
          style: GoogleFonts.quicksand(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomTextField(String label, String hint) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.quicksand(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
            ),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.quicksand(
                color: Colors.grey[400],
                fontWeight: FontWeight.w600,
              ),
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivateToggle() {
    return GestureDetector(
      onTap: () => setState(() => isPrivate = !isPrivate),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isPrivate ? primaryPurple.withOpacity(0.05) : Colors.grey[50],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isPrivate
                ? primaryPurple.withOpacity(0.1)
                : Colors.grey[100]!,
          ),
        ),
        child: Row(
          children: [
            Text(isPrivate ? '🔒' : '🔓', style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Gasto Privado",
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold,
                      color: isPrivate ? primaryPurple : Colors.grey[700],
                    ),
                  ),
                  Text(
                    "Solo tú verás este detalle",
                    style: GoogleFonts.quicksand(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: isPrivate,
              onChanged: (v) => setState(() => isPrivate = v),
              activeColor: primaryPurple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isExpense
              ? [lilaPastel, rosaPastel]
              : [const Color(0xFF84fab0), const Color(0xFF8fd3f4)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isExpense ? lilaPastel : incomeGreen).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          "Registrar ${isExpense ? 'Gasto' : 'Ingreso'}",
          style: GoogleFonts.quicksand(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
