const elmStaticHtml = require("elm-static-html-lib").default;
async function __render__() {

    // globals: process (node)
    global.document = global.document || {};
    global.document.location = global.document.location || {
        hash: "",
        host: "",
        hostname: "",
        href: "",
        origin: "",
        pathname: "",
        port: "",
        protocol: "",
        search: "",
    };



    const options = {
        model: { // Model.ContactList
            entries: [
                // Model.Contact
                {
                    id: 333,
                    first_name: "Robot",
                    last_name: "Army",
                    gender: 3,
                    birth_date: "11/20/1979",
                    location: "home",
                    phone_number: "222-222-2222",
                    email: "robotarmy@ram9.cc",
                    headline: "Robot Army Made",
                    picture: ""
                }, {
                    id: 123,
                    first_name: "Jaine",
                    last_name: "Smitherson",
                    gender: 3,
                    birth_date: "11/20/1983",
                    location: "mt rushmore",
                    phone_number: "333-333-3333",
                    email: "js@rushmore.com",
                    headline: "Nice Person",
                    picture: ""
                }
            ],
            page_number: 1,
            total_entries: 2,
            total_pages: 1

        },
        decoder: "StaticMain.decodeModel"
    };
    try {
        return await new Promise(function(resolve, reject) {



            elmStaticHtml("/Users/o_o/devhome/serve_elm"
                          , "StaticMain.viewWithModel"
                          , options
                         ).then(function(html) {
                             resolve(html);
			                       console.log(html);
                         });



        });
    } catch(error) {
        console.log("ERROR:"+error)
    }
}
var result = __render__()
console.log(result);

