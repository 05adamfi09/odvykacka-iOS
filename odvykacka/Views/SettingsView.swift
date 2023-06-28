//
//  SettingsView.swift
//  odvykacka
//
//  Created by Filip Adámek on 29.05.2023.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject var viewModel: MainViewModel

    
    @State var isPickerPresented = false
    @State var isProfilePicturePickerPresented = false
    @State var selectedImage: UIImage?
    @State var selectedProfileImage: UIImage?
    @State var isSaveAlertPresented = false
    @State var userName: String?
    @State var userAddiction: String?
    
    var body: some View {
        VStack(alignment: .center){
            
            
            Button(action: {
                isProfilePicturePickerPresented = true
            }) {
                Image(uiImage: selectedProfileImage ?? UIImage(named: "profile_picture") ?? UIImage())
                    .resizable()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
            }
            .sheet(isPresented: $isProfilePicturePickerPresented, onDismiss: nil){
                ImagePicker(selectedImage: $selectedProfileImage, isPickerPresented: $isProfilePicturePickerPresented)
            }
            
            Text("Nickname: " + (userName ?? "Unknown"))
            Text("Addiction: " + (userAddiction ?? "Unknown"))
            
            Button{
                isPickerPresented.toggle()
            } label: {
                Text("SELECT MOTIVATION IMAGE")
                    .bold()
                    .frame(width: 200, height: 50)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $isPickerPresented, onDismiss: nil){
                ImagePicker(selectedImage: $selectedImage, isPickerPresented: $isPickerPresented)
            }
            
            Spacer()
            
            Button{
                viewModel.deleteProfile()
            }label: {
                Text("DELETE PROFILE")
                    .bold()
                    .frame(width: 200, height: 50)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Spacer()
            
            Text("Version 1.0")
                
        }
        .toolbar{
            ToolbarItemGroup(placement: .principal){
                Text("Settings")
            }
            ToolbarItemGroup(placement: .navigationBarTrailing){
                Button{
                    viewModel.updateProfile(newProfilePicture: selectedProfileImage!, newMotivationPicture: selectedImage!)
                    isSaveAlertPresented = true
                    
                } label: {
                    Text("Save changes")
                }
            }
        }
        .alert(isPresented: $isSaveAlertPresented){
            Alert(title: Text("Changes has been saved"), dismissButton: .default(Text("Ok")))
        }
        .onAppear(){
            selectedImage = viewModel.getUser()?.motivationPicture
            selectedProfileImage = viewModel.getUser()?.profilePicture
            userName = viewModel.getUser()?.nickname
            userAddiction = viewModel.getUser()?.addiction
        }
    }
}
/*
 struct SettingsView_Previews: PreviewProvider {
 static var previews: some View {
 SettingsView()
 }
 }
 */
