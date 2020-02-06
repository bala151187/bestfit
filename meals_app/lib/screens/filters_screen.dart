import 'package:flutter/material.dart';
import '../widgets/main_drawer.dart';

class FiltersScreen extends StatefulWidget {
  static const routeName = '/filters';
  final Function saveFilters;
  final Map<String, bool> currentFilters;

  FiltersScreen(this.currentFilters, this.saveFilters);

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  var _glutenFree = false;
  var _vegetrain = false;
  var _vegan = false;
  var _lactose = false;

  @override
  initState() {
    _glutenFree = widget.currentFilters['gluten'];
    _lactose = widget.currentFilters['lactose'];
    _vegan = widget.currentFilters['vegan'];
    _vegetrain = widget.currentFilters['vegetrain'];
    super.initState();
  }

  Widget _buildSwitchListTile(String title, String description,
      bool currentVlue, Function updateValue) {
    return SwitchListTile(
      title: Text(title),
      value: currentVlue,
      subtitle: Text(
        description,
      ),
      onChanged: updateValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Filters"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.save),
                onPressed: () {
                  final selectedFilter = {
                    'gluten': _glutenFree,
                    'lactose': _lactose,
                    'vegan': _vegan,
                    'vegetrain': _vegetrain,
                  };
                  widget.saveFilters(selectedFilter);
                })
          ],
        ),
        drawer: MainDrawer(),
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                'Adjust your meal selection!',
                style: Theme.of(context).textTheme.title,
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  _buildSwitchListTile(
                    'Gluten-free',
                    'Only gluten-free meals.',
                    _glutenFree,
                    (newValue) {
                      setState(() {
                        _glutenFree = newValue;
                      });
                    },
                  ),
                  _buildSwitchListTile(
                    'Lactose-free',
                    'Only lactose-free meals.',
                    _lactose,
                    (newValue) {
                      setState(() {
                        _lactose = newValue;
                      });
                    },
                  ),
                  _buildSwitchListTile(
                    'Vegetrain',
                    'Only vegetrain meals.',
                    _vegetrain,
                    (newValue) {
                      setState(() {
                        _vegetrain = newValue;
                      });
                    },
                  ),
                  _buildSwitchListTile(
                    'Vegan',
                    'Only vegan meals.',
                    _vegan,
                    (newValue) {
                      setState(() {
                        _vegan = newValue;
                      });
                    },
                  )
                ],
              ),
            )
          ],
        ));
  }
}
