/*
 * makePost.qml
 *
 *      Author: Daniele (b0unc3) Maio
 */

import bb.cascades 1.0
import bb.system 1.0
import bb.cascades.pickers 1.0

Page {
    id: mp_mpp

    property bool post_showpage;

    attachedObjects: [
        CustomIndicator {
            id: mp_ci
        },
        SystemProgressToast {
            id: mp_spt
            progress: -1
            body: qsTr("Creating the new post, please wait");
            state: SystemUiProgressState.Active
        },
        FilePicker {
            id: mp_filePicker
            type: FileType.Picture
            title: qsTr("Select Picture")
            mode: FilePickerMode.Picker
            onFileSelected: {
		wpu.uploadFile(selectedFiles[0]);
                wpu.dataReady.connect(mp_mpp.mp_onDataReady);
                mp_ci.body = "Uploading picture\nplease wait...";
                mp_ci.open();
            }
        }
    ]
    
    actions: [
        ActionItem {
            title: "Save"
            imageSource: "asset:///images/save.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            
            onTriggered: {
                mp_ci.body = "Creating the new " +((mp_mpp.post_showpage) ? "page" : "post") + "\nplaease wait...";
                mp_ci.open();
                wpu.makePost(mp_mpp.post_showpage, posttitle.text, postcontent.text.trim(), ((posttype.selectedValue) ? posttype.selectedValue : "" ) , poststatus.selectedValue);
                if ( mp_mpp.post_showpage )
                	 wpu.dataReady_newPage.connect(mp_mpp.mp_onDataReady);
                else wpu.dataReady_newPost.connect(mp_mpp.mp_onDataReady);
            }
        },
        ActionItem {
            title: qsTr("Add Image");
            imageSource: "asset:///images/addimage.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            
            onTriggered: {
                mp_filePicker.open();
            }
        }
        
    ]
    
    function mp_onDataReady()
    {
        var mp_a = wpu.getRes();
        
        if (mp_a['newpostid'] )
        {
            mp_ci.close();
            if ( !post_showpage )
            {
            	navpostpane.pop();
            	navpostpane.firstPage.post_loadData();
            } else {
                navpagepane.pop();
                navpagepane.firstPage.post_loadData();
            }
        } else if (mp_a['file'] )
        {
            postcontent.editor.insertPlainText("<img src=\"" + mp_a['url'] + "\" alt=\"desc\" />"); // width=\"480\" height=\"800\" class=\"aligncenter\" />");
            mp_ci.close();
        } else console.log("wrg : smtg wrong"); /* TODO */
    }


    titleBar: TitleBar {
        title: (!post_showpage) ? qsTr("New Post") : qsTr("New Page")
    }

    content: Container {
        layout: StackLayout { }

        TextField {
            horizontalAlignment: HorizontalAlignment.Fill
            id: posttitle

            hintText: qsTr("Post Title");
        }
        
        TextArea {
            id: postcontent
            editable: true
            hintText: qsTr("Post Content");
            
            minHeight: 150
            preferredHeight: 400
        }
        Divider {
            
        
        }
        /*
        TextField {
            horizontalAlignment: HorizontalAlignment.Fill
            id: posttags
            hintText: qsTr("Post tags (Separate tags with commas)");
        }
        
        
        
         * ***FIXME***
         * not yet fully implemented
        Button {
            text: qsTr("Categories")
            
            onClicked: {
                customdialogcat.open();
            }
        }
*/
        
        DropDown {
            id: poststatus
            title: qsTr("Status");
            Option {
                text: qsTr("Public");
                value: "public"
                selected: true
            }
            Option {
                text: qsTr("Private");
                value: "private"
            }
        }
        
        DropDown {
            id: posttype
            title: qsTr("Format");
            visible: !post_showpage
            
            Option {
                text: qsTr("Standard");
                value: "post"
                selected: true
            }
            Option {
                text: qsTr("Aside");
                value: "aside"
            }
            Option {
                text: qsTr("Image");
                value: "image"
            }
            Option {
                text: qsTr("Video");
                value: "video"
            }
            Option {
                text: qsTr("Quote");
                value: "quote"
            }
            Option {
                text: qsTr("Link");
                value: "link"
            }
        }

    }
}

