import { LightningElement } from 'lwc';

import getUsers from '@salesforce/apex/userSendController.getUsers'

import createUsers from '@salesforce/apex/userSendController.createUsers'

const columns = [
    {label:'Name', fieldName:'Name'},
]

export default class UserSendCmp extends LightningElement {

    selectedUserIdList=[];
   
    searchValue

    displayResult

    columns = columns

    rowInfo
    
    handleSearch(event){
        this.searchValue=event.target.value;
        this.ImperativeCall();
    }

    getSelectedIdAction(event){
        const selectedUserRows = event.detail.selectedRows;
        window.console.log('selectedUserRows#### ' + JSON.stringify(selectedUserRows));
        this.selectedUserRows=[];

        for (let i = 0; i<selectedUserRows.length; i++){
            this.selectedUserIdList.push(selectedUserRows[i].Id);
            console.log('@%@%@ SELECTED ROW IDs @%@%@ :-',selectedUserRows[i].Id)
        }
        
    }


    createUserAction(){
        this.ImperativeCall()
    }

    ImperativeCall(){
        getUsers({str:this.searchValue})
        .then((result)=>{
            this.displayResult=result
        })
        .catch((error)=>{
            console.log(error)
        })

        createUsers({conObj:this.selectedUserIdList})
        .then((result)=>{
            this.displayResult=result
        })
        .catch((error)=>{
            console.log(error)
        })
    }
}