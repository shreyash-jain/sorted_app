import { Component, OnInit } from '@angular/core';
import {
  FormBuilder,
  FormControl,
  FormGroup,
  Validators,
} from '@angular/forms';

@Component({
  selector: 'app-contact-us',
  templateUrl: './contact-us.component.html',
  styleUrls: ['./contact-us.component.scss'],
})
export class ContactUsComponent implements OnInit {
  contactForm: FormGroup;
  submitted = false;

  constructor(private formBuilder: FormBuilder) {}

  ngOnInit(): void {
    this.submitted = false;
    this.contactForm = this.formBuilder.group({
      name: ['', Validators.required],
      phone: [
        '',
        [
          Validators.required,
          Validators.maxLength(10),
          Validators.minLength(10),
        ],
      ],
      email: ['', [Validators.required, Validators.email]],
      message: ['', Validators.required],
    });
  }

  public get formControl() {
    return this.contactForm.controls;
  }

  onSubmit() {
    this.submitted=true;
    if (this.contactForm.invalid) return;
    this.submitted = false;
  }
}
