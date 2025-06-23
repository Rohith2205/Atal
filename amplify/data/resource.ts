import { type ClientSchema, a, defineData } from '@aws-amplify/backend';

/*== STEP 1 ===============================================================
The section below creates a Todo database table with a "content" field. Try
adding a new "isDone" field as a boolean. The authorization rule below
specifies that any unauthenticated user can "create", "read", "update", 
and "delete" any "Todo" records.
=========================================================================*/
const schema = a.schema({

  UserTable: a.model({
    id: a.id(),
    name: a.string(),
    reg_no: a.string(),
    email: a.email(),
    phone: a.string(),
    device_id: a.string(),
    university: a.string(),
    district: a.string(),
    mandal: a.string(),
    college: a.string(),
    team_code: a.id(),
    isPolicy: a.boolean().default(false),
    gender: a.enum(['MALE', 'FEMALE', 'OTHER']),
    branch: a.string(),
    attendance : a.hasMany('attendanceTable','user_id'),
    suggestion: a.hasMany('SuggestionsTable','user_id'),
    team: a.belongsTo('TeamTable','team_code')
  }).authorization((allow) => [allow.guest()]),

  attendanceTable: a.model({
    user_id: a.id(),
    user: a.belongsTo('UserTable','user_id'),
    longitude: a.float(),
    latitude: a.float(),
    no_of_boys: a.integer(),
    no_of_girls: a.integer(),
    total: a.integer(),
    teachers: a.integer(),
    photo: a.string(),
    start_time: a.time(),
    end_time: a.time(),
    class_attended: a.json(),
    module_name: a.string(),
    module_no: a.integer(),
    remarks: a.string(),
    timestamp: a.timestamp(),
    topics_covered: a.string()
  }).authorization((allow) => [allow.guest()]),

  TeamTable: a.model({
    team_code: a.id(),
    team_members: a.json(),
    school_name: a.string(),
    district: a.string(),
    mandal: a.string(),
    schoolUID: a.integer(),
    modules: a.json(),
    user: a.hasMany('UserTable','team_code')
  }).authorization((allow) => [allow.guest()]),

  SuggestionsTable: a.model({
    user_id:a.id(),
    user:a.belongsTo('UserTable','user_id',),
    suggestionID: a.integer(),
    type: a.string(),
    concern: a.string(),
    photo: a.string(),
    schoolUID: a.integer(),
  }).authorization((allow) => [allow.guest()]),

  ResourceTable: a.model({
    moduleID: a.integer().required(),
    module_no: a.integer(),
    module_name: a.string(),
    url: a.string(),
    module_photo: a.string(),
    isValid: a.boolean(),
    teamID_list: a.json()
  }).authorization((allow) => [allow.guest()])
});


export type Schema = ClientSchema<typeof schema>;

export const data = defineData({
  schema,
  authorizationModes: {
    defaultAuthorizationMode: 'identityPool',
  },
});

/*== STEP 2 ===============================================================
Go to your frontend source code. From your client-side code, generate a
Data client to make CRUDL requests to your table. (THIS SNIPPET WILL ONLY
WORK IN THE FRONTEND CODE FILE.)

Using JavaScript or Next.js React Server Components, Middleware, Server
Actions or Pages Router? Review how to generate Data clients for those use
cases: https://docs.amplify.aws/gen2/build-a-backend/data/connect-to-API/
=========================================================================*/

/*
"use client"
import { generateClient } from "aws-amplify/data";
import type { Schema } from "@/amplify/data/resource";

const client = generateClient<Schema>() // use this Data client for CRUDL requests
*/

/*== STEP 3 ===============================================================
Fetch records from the database and use them in your frontend component.
(THIS SNIPPET WILL ONLY WORK IN THE FRONTEND CODE FILE.)
=========================================================================*/

/* For example, in a React component, you can use this snippet in your
  function's RETURN statement */
// const { data: todos } = await client.models.Todo.list()

// return <ul>{todos.map(todo => <li key={todo.id}>{todo.content}</li>)}</ul>