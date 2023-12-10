part of 'widgets.dart';

class CardProvince extends StatefulWidget {
  final Costs cost;
  const CardProvince(this.cost);

  @override
  State<CardProvince> createState() => _CardProvinceState();
}

class _CardProvinceState extends State<CardProvince> {
  @override
  Widget build(BuildContext context) {
    Costs c = widget.cost;
    return Card(
      color: Color(0xFFFFFFFFFF),
      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        title:
            // Use appropriate property for the title
            Text("${c.description} (${c.service})"),
        // Text("test"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // if (costsList != null && costsList.isNotEmpty)
            //   for (Cost cost in c)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Biaya: Rp.${c.cost[0].value}"),
                Text("Estimasi Sampai: ${c.cost[0].etd}"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
