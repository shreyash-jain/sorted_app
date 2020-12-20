import { Component, OnInit } from '@angular/core';
import { FormControl, FormGroup } from '@angular/forms';

@Component({
  selector: 'app-contact-us',
  templateUrl: './contact-us.component.html',
  styleUrls: ['./contact-us.component.scss']
})
export class ContactUsComponent implements OnInit {
  form = new FormGroup({
    name: new FormControl(),
    phone: new FormControl(),
    email: new FormControl(),
    message: new FormControl()
  });

  constructor() { }

  ngOnInit(): void {
  }

  Submit(event: any) {
    console.log(event);
  }

  formSubmit() {
    console.log(this.form.value);
  }
}
