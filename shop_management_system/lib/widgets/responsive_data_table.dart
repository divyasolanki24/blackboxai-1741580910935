import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_management_system/widgets/responsive_builder.dart';

class ResponsiveDataTable extends StatelessWidget {
  final List<String> columns;
  final List<DataRow> rows;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRefresh;
  final Function(String)? onSearch;
  final int? rowsPerPage;
  final Function(int?)? onRowsPerPageChanged;
  final int? currentPage;
  final int totalItems;
  final Function(int)? onPageChanged;

  const ResponsiveDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.isLoading = false,
    this.errorMessage,
    this.onRefresh,
    this.onSearch,
    this.rowsPerPage,
    this.onRowsPerPageChanged,
    this.currentPage,
    this.totalItems = 0,
    this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (onSearch != null || onRefresh != null) ...[
              _buildTableHeader(),
              const SizedBox(height: 16),
            ],
            if (errorMessage != null)
              _buildErrorMessage()
            else if (isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: ResponsiveBuilder(
                  mobile: _buildMobileView(),
                  tablet: _buildTableView(),
                  desktop: _buildTableView(),
                ),
              ),
            if (rowsPerPage != null) ...[
              const SizedBox(height: 16),
              _buildPagination(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Row(
      children: [
        if (onSearch != null)
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: onSearch,
            ),
          ),
        if (onSearch != null && onRefresh != null)
          const SizedBox(width: 16),
        if (onRefresh != null)
          ElevatedButton.icon(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
          ),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            errorMessage!,
            style: const TextStyle(color: Colors.red),
          ),
          if (onRefresh != null) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTableView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: columns
            .map((column) => DataColumn(
                  label: Text(
                    column,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ))
            .toList(),
        rows: rows,
      ),
    );
  }

  Widget _buildMobileView() {
    return ListView.separated(
      itemCount: rows.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, rowIndex) {
        final row = rows[rowIndex];
        return ExpansionTile(
          title: Text(row.cells.first.child.toString()),
          children: [
            for (var i = 1; i < columns.length; i++)
              ListTile(
                title: Text(columns[i]),
                trailing: row.cells[i].child,
              ),
          ],
        );
      },
    );
  }

  Widget _buildPagination() {
    final int pageCount = (totalItems / (rowsPerPage ?? 10)).ceil();
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (onRowsPerPageChanged != null)
          Row(
            children: [
              const Text('Rows per page:'),
              const SizedBox(width: 8),
              DropdownButton<int>(
                value: rowsPerPage,
                items: [10, 20, 50, 100]
                    .map((value) => DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        ))
                    .toList(),
                onChanged: onRowsPerPageChanged,
              ),
            ],
          ),
        if (onPageChanged != null && pageCount > 1)
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: currentPage == 1
                    ? null
                    : () => onPageChanged!(currentPage! - 1),
              ),
              Text('$currentPage of $pageCount'),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: currentPage == pageCount
                    ? null
                    : () => onPageChanged!(currentPage! + 1),
              ),
            ],
          ),
      ],
    );
  }
}
