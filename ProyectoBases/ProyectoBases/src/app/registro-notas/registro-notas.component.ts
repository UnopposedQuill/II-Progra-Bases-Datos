import { Component, OnInit } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';

@Component({
  selector: 'app-registro-notas',
  templateUrl: './registro-notas.component.html',
  styleUrls: ['./registro-notas.component.scss']
})

export class RegistroNotasComponent implements OnInit {
  frmRegistroNotas: FormGroup; 
  lengt = 2;
  constructor(private fb: FormBuilder) {
    this.frmRegistroNotas = this.fb.group({
      nombre: ['',Validators.required],
      nota: ['',Validators.required],
      confirmar: ['',Validators.required],

    })
   }

  ngOnInit() {
  }

  validacionNota(){
    const frm = this.frmRegistroNotas.value;
    if (frm.confirmar==frm.nota)
      return true;
    else 
      return false;
    
  }

  registroNota(){

  }
}
