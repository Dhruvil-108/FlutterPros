import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

void main() {
  runApp(const CVCreatorApplication());
}

class CVCreatorApplication extends StatelessWidget {
  const CVCreatorApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CV Creator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),

        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
      home: const CVBuilderScreen(),
    );
  }
}

class CVBuilderScreen extends StatefulWidget {
  const CVBuilderScreen({super.key});

  @override
  State<CVBuilderScreen> createState() => _CVBuilderScreenState();
}

class _CVBuilderScreenState extends State<CVBuilderScreen> {
  final TextEditingController fullNameField = TextEditingController();
  final TextEditingController emailAddressField = TextEditingController();
  final TextEditingController contactNumberField = TextEditingController();
  final TextEditingController academicBackgroundField = TextEditingController();

  // Dynamic Skills
  final TextEditingController newSkillField = TextEditingController();
  final List<String> skillsList = [];

  // Dynamic Work Experience
  final TextEditingController newExperienceField = TextEditingController();
  final List<String> experiencesList = [];

  void addNewSkill() {
    final skill = newSkillField.text.trim();
    if (skill.isNotEmpty) {
      setState(() => skillsList.add(skill));
      newSkillField.clear();
    }
  }

  void deleteSkill(String skill) {
    setState(() => skillsList.remove(skill));
  }

  void addNewExperience() {
    final exp = newExperienceField.text.trim();
    if (exp.isNotEmpty) {
      setState(() => experiencesList.add(exp));
      newExperienceField.clear();
    }
  }

  void deleteExperience(String exp) {
    setState(() => experiencesList.remove(exp));
  }

  void resetAllFields() {
    fullNameField.clear();
    emailAddressField.clear();
    contactNumberField.clear();
    academicBackgroundField.clear();
    skillsList.clear();
    experiencesList.clear();
    newSkillField.clear();
    newExperienceField.clear();
    setState(() {});
  }

  void createPDFDocument() async {
    final pdfDoc = pw.Document();

    pdfDoc.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  fullNameField.text,
                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  '${emailAddressField.text} ${contactNumberField.text.isNotEmpty ? " • ${contactNumberField.text}" : ""}',
                ),
                pw.Divider(thickness: 2, color: PdfColors.grey),

                pw.SizedBox(height: 10),
                pw.Text(
                  'Education',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(academicBackgroundField.text),

                pw.SizedBox(height: 10),
                pw.Text(
                  'Experience',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                ...experiencesList.map((exp) => pw.Bullet(text: exp)),

                pw.SizedBox(height: 10),
                pw.Text(
                  'Skills',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: skillsList
                      .map(
                        (skill) => pw.Container(
                          padding: const pw.EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: pw.BoxDecoration(
                            color: PdfColors.deepPurple100,
                            borderRadius: pw.BorderRadius.circular(4),
                          ),
                          child: pw.Text(skill),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfDoc.save(),
    );
  }

  Widget buildInputField(
    String labelText,
    IconData iconData,
    TextEditingController fieldController, {
    int lineCount = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: fieldController,
        maxLines: lineCount,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(iconData, color: Colors.deepPurple),
        ),
      ),
    );
  }

  Widget buildSkillsModule() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.stars_rounded, color: Colors.deepPurple, size: 28),
                const SizedBox(width: 12),
                const Text(
                  "Professional Skills",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: newSkillField,
                    decoration: InputDecoration(
                      labelText: "Enter a skill",
                      prefixIcon: Icon(
                        Icons.lightbulb_outline,
                        color: Colors.amber.shade700,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onSubmitted: (_) => addNewSkill(),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: addNewSkill,
                  icon: const Icon(Icons.add),
                  label: const Text("Add"),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            ),
            if (skillsList.isNotEmpty) ...[
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: skillsList
                    .map(
                      (skill) => Chip(
                        label: Text(
                          skill,
                          style: const TextStyle(fontSize: 14),
                        ),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () => deleteSkill(skill),
                        backgroundColor: Colors.deepPurple.shade50,
                        side: BorderSide(color: Colors.deepPurple.shade200),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildExperienceModule() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.work_rounded, color: Colors.deepPurple, size: 28),
                const SizedBox(width: 12),
                const Text(
                  "Work Experience",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: newExperienceField,
                    decoration: InputDecoration(
                      labelText: "Job title • Company • Duration",
                      prefixIcon: Icon(
                        Icons.business_center,
                        color: Colors.blue.shade700,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onSubmitted: (_) => addNewExperience(),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: addNewExperience,
                  icon: const Icon(Icons.add),
                  label: const Text("Add"),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            ),
            if (experiencesList.isNotEmpty) ...[
              const SizedBox(height: 20),
              Column(
                children: experiencesList
                    .map(
                      (exp) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.work_outline,
                                size: 20,
                                color: Colors.blue.shade700,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                exp,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_rounded),
                              color: Colors.red.shade600,
                              onPressed: () => deleteExperience(exp),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'CV Builder',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person_rounded,
                          color: Colors.deepPurple,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Personal Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    buildInputField('Full Name', Icons.badge, fullNameField),
                    buildInputField(
                      'Email Address',
                      Icons.email_rounded,
                      emailAddressField,
                    ),
                    buildInputField(
                      'Phone Number',
                      Icons.phone_rounded,
                      contactNumberField,
                    ),
                    buildInputField(
                      'Academic Background',
                      Icons.school_rounded,
                      academicBackgroundField,
                      lineCount: 3,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            buildExperienceModule(),
            const SizedBox(height: 20),
            buildSkillsModule(),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton.icon(
                onPressed: createPDFDocument,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.picture_as_pdf_rounded, size: 24),
                label: const Text(
                  'Generate PDF Resume',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                onPressed: resetAllFields,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade700,
                  side: BorderSide(color: Colors.red.shade700, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.clear_all_rounded, size: 24),
                label: const Text(
                  'Clear All Fields',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
