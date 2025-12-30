import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/death_note_provider.dart';
import 'death_card.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deathProvider = context.watch<DeathNoteProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Death Notes',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
        centerTitle: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await context.read<AuthProvider>().logout();
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add'),
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: deathProvider.notesStream,
        builder: (_, snapshot) {
          final notes = snapshot.data ?? [];
          final monthNames = [
            'January',
            'February',
            'March',
            'April',
            'May',
            'June',
            'July',
            'August',
            'September',
            'October',
            'November',
            'December',
          ];

          return Column(
            children: [
              Card(
                margin: EdgeInsets.all(12),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButton<int>(
                              value: deathProvider.year,
                              hint: Text(
                                'Filter by Year',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              isExpanded: true,
                              underline: SizedBox(),
                              items: List.generate(10, (i) {
                                final y = DateTime.now().year - i;
                                return DropdownMenuItem(
                                  value: y,
                                  child: Text(y.toString()),
                                );
                              }),
                              onChanged: (v) => deathProvider.setFilter(
                                v,
                                deathProvider.month,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: DropdownButton<int>(
                              value: deathProvider.month,
                              hint: Text(
                                'Filter by Month',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              isExpanded: true,
                              underline: SizedBox(),
                              items: List.generate(12, (i) {
                                final m = i + 1;
                                return DropdownMenuItem(
                                  value: m,
                                  child: Text(monthNames[i]),
                                );
                              }),
                              onChanged: (v) => deathProvider.setFilter(
                                deathProvider.year,
                                v,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Records: ${notes.length}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () =>
                                deathProvider.setFilter(null, null),
                            icon: Icon(Icons.clear),
                            label: Text('Cancel'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: snapshot.connectionState == ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : snapshot.hasError
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.orange,
                                size: 48,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Unable to Load Records',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () =>
                                    deathProvider.setFilter(null, null),
                                child: Text('Try Again'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : notes.isEmpty
                    ? Center(child: Text('No death records found'))
                    : ListView.builder(
                        itemCount: notes.length,
                        itemBuilder: (_, i) => DeathCard(model: notes[i]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
