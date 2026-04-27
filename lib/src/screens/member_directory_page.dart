part of '../society_app.dart';

class MemberDirectoryPage extends StatefulWidget {
  const MemberDirectoryPage({
    super.key,
    required this.api,
  });

  final MockSocietyApi api;

  @override
  State<MemberDirectoryPage> createState() => _MemberDirectoryPageState();
}

class _MemberDirectoryPageState extends State<MemberDirectoryPage> {
  final _searchController = TextEditingController();
  String _selectedWing = 'All Wings';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<AppUser> get _members {
    final query = _searchController.text.trim().toLowerCase();
    return widget.api.data.users.where((user) {
      final matchesWing = _selectedWing == 'All Wings' ||
          '${user.wing} Wing' == _selectedWing;
      final matchesQuery = query.isEmpty ||
          user.name.toLowerCase().contains(query) ||
          user.flat.toLowerCase().contains(query);
      return matchesWing && matchesQuery;
    }).toList();
  }

  Future<void> _openAddMember() async {
    final created = await Navigator.of(context).push<AppUser>(
      MaterialPageRoute(
        builder: (_) => AddMemberPage(api: widget.api),
      ),
    );

    if (!mounted || created == null) {
      return;
    }

    setState(() {});
    showAppMessage(context, '${created.name} added to the member directory.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildDetailAppBar(
        context,
        title: 'Members (${widget.api.data.society.memberCount})',
        actions: [
          IconButton(
            onPressed: _openAddMember,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: _openAddMember,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'Search by name or flat',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          _FilterRow(
            labels: const ['All Wings', 'A Wing', 'B Wing', 'C Wing'],
            selected: _selectedWing,
            onSelected: (value) {
              setState(() {
                _selectedWing = value;
              });
            },
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
              itemBuilder: (context, index) {
                final user = _members[index];
                return _MemberTile(user: user);
              },
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemCount: _members.length,
            ),
          ),
        ],
      ),
    );
  }
}

