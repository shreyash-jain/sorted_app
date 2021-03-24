import { Component, OnInit } from '@angular/core';
import { ContactUsService } from '../../contact-us.service';
import { ActivatedRoute } from '@angular/router';
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
  submitted = true;

  constructor(private route: ActivatedRoute,private formBuilder: FormBuilder, private contactService: ContactUsService) { }

  ngOnInit(): void {
    console.log("here55");
    


    this.submitted = true;
    this.contactForm = this.formBuilder.group({
      name: ['', Validators.required],
      phone: [
        '',
        [
          Validators.required,
          
        ],
      ],
      email: ['', [Validators.required, Validators.email]],
      message: ['', Validators.required],
    });
  }

  public get formControl() {
    return this.contactForm.controls;
  }

  public onSubmit() {
    console.log("here");
    //this.submitted = true;
    console.log("here");
    if (this.contactForm.invalid) return;
    console.log(this.contactForm.value['name']);
    this.contactService.sendMessage([], "name=" + "\"" + this.contactForm.value['name'] + "\"" + "&email=" + "\"" + this.contactForm.value['email'] + "\"" + "&message=" + "\"" + this.contactForm.value['message'] + "\"" + "&phone=" + "\"" + this.contactForm.value['phone'] + "\"");

    //this.submitted = false;
  }
}
