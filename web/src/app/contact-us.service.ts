import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
@Injectable({
  providedIn: 'root'
})
export class ContactUsService {

  constructor(private _http: HttpClient) {

  }
  sendMessage(body: any, endcontent: String) {
    console.log("here3 " + endcontent);
    console.log("https://us-central1-sorted-98c02.cloudfunctions.net/sendEmail?" + endcontent);
    return this._http.post("https://us-central1-sorted-98c02.cloudfunctions.net/sendEmail?"  + endcontent , {});
  }
}
