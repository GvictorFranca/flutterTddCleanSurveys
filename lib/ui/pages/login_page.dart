import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Image.network('https://www.pngfind.com/pngs/m/80-804141_logo-render-png-anime-bleach-logo-transparent-png.png'),
            ),
            Text('Login'),
            Form(child: 
            Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    icon: Icon(Icons.email)
                  ),
                  keyboardType: TextInputType.emailAddress
                ),
                    TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    icon: Icon(Icons.email)
                  ),
                  obscureText: true,
                ),
                RaisedButton(
                  onPressed: () {},
                  child: Text('Entrar'),
                ),
                FlatButton.icon(
                  onPressed: null,
                  icon: Icon(Icons.person),
                  label: Text('Criar conta')
                )
              ],
            ),
            ),
          ],
        ),
      ),
    );
  }
}
