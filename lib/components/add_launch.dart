import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spending_control/database/launch.dart';
import 'package:spending_control/models/launch.dart';

class _SubmitButton extends StatelessWidget {
  String type;
  Launch launch;

  _SubmitButton(this.type, this.launch);

  void saveLaunch(BuildContext context, FormGroup form) async {
    if (this.launch is Launch) {
      String description = form.control("description").value;
      this.launch.setDescription(description);
      if (form.control("value").value is double) {
        this.launch.setValue(form.control("value").value);
      } else {
        String strValue = form.control("value").value;
        double value = double.tryParse(strValue.replaceAll(".", "").replaceAll(",", "."));
        this.launch.setValue(value);
      }
      await updateLaunchDb(this.launch).then((value) {
        Navigator.pop(context, this.launch);
      });
    } else {
      SharedPreferences.getInstance().then((prefs) async {
        int monthPref = prefs.getInt("calendarMonth");
        int yearPref = prefs.getInt("calendarYear");
        String description = form.control("description").value;
        String strValue = form.control("value").value;
        double value = 0;
        try {
          value = double.tryParse(strValue.replaceAll(".", "").replaceAll(",", "."));
        } catch (e) {
          debugPrint(e);
        }
        Launch launch = Launch(null, description, monthPref, yearPref, value, this.type, false);
        await saveLaunchDb(launch).then((value) {
          print(value.toString());
          Navigator.pop(context, launch);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final form = ReactiveForm.of(context);
    return FlatButton(
      disabledColor: Colors.grey,
      onPressed: (form.valid ? () => this.saveLaunch(context, form) : null),
      child: Text(
        "Salvar",
        style: TextStyle(color: Colors.white),
      ),
      color: Theme.of(context).primaryColor,
    );
  }
}

Future<Launch> openAddLaunch(context, String type, {Launch launch}) {
  final form = FormGroup({
    'description': FormControl(defaultValue: (launch is Launch ? launch.description : null), validators: [
      Validators.required,
    ]),
    'value': FormControl(defaultValue: (launch is Launch ? launch.value : null), validators: [
      Validators.required,
    ]),
  });

  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
    ),
    isScrollControlled: true,
    builder: (BuildContext bc) {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(
            16,
            32,
            16,
            MediaQuery.of(bc).viewInsets.bottom + 32,
          ),
          child: ReactiveForm(
            formGroup: form,
            child: Wrap(
              runSpacing: 16.0,
              children: <Widget>[
                ReactiveTextField(
                  formControlName: "description",
                  validationMessages: {
                    ValidationMessage.required: "Obrigatório",
                  },
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.description),
                    labelText: 'Descrição',
                  ),
                ),
                ReactiveTextField(
                  formControlName: "value",
                  validationMessages: {
                    ValidationMessage.required: "Obrigatório",
                  },
                  inputFormatters: [
                    TextInputFormatter.withFunction(
                      (oldValue, newValue) {
                        double value = double.parse(newValue.text.replaceAll(",", "").replaceAll(".", ""));
                        final formatter = NumberFormat("#,##0.00", "pt_BR");
                        String newText = formatter.format(value / 100);
                        return newValue.copyWith(
                          text: newText,
                          selection: TextSelection.collapsed(
                            offset: newText.length,
                          ),
                        );
                      },
                    ),
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.attach_money),
                    labelText: 'Valor',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SizedBox(
                    width: 100000,
                    height: 48,
                    child: _SubmitButton(type, launch),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
